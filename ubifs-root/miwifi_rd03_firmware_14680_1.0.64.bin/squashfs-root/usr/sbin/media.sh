#!/bin/sh


. /lib/functions.sh
. /lib/miwifi/miwifi_functions.sh

readonly PSUCI="port_service"
SERVICE="$1"
CMD="$2"

config_load "$PSUCI"
config_get ENABLE "$SERVICE" enable
config_get PORTS "$SERVICE" ports
config_get VID "${SERVICE}_attr" vid
config_get PRI "${SERVICE}_attr" priority


start() {
    local ifname=""
    local list_ifnames_service=""

    [ "$ENABLE" != "1" ] || [ -z "$PORTS" ] || [ "$VID" = "-1" ] && return

    for port in $PORTS
    do
        ifname=$(port_map config get "$port" ifname)
        append list_ifnames_service "$ifname"
    done

    if [ "$VID" = "0" ]; then
        # bridge mode
        uci batch <<-EOF
            set network.internet=interface
            set network.internet.type=bridge
            set network.internet.macaddr="$(uci -q get network.wan.macaddr)"
            set network.internet.ifname="$list_ifnames_service"
            commit network
		EOF
    else
        # media mode
        [ "$PRI" != "-1" ] && {
            for ifname in $list_ifnames_service
            do
                vconfig set_egress_map "$ifname" 0 "$PRI"
                vconfig set_ingress_map "$ifname" 0 "$PRI"
            done
        }

        uci batch <<-EOF
            set network."$SERVICE"=interface
            set network."$SERVICE".type=bridge
            set network."$SERVICE".force_link=1
            set network."$SERVICE".ifname="$list_ifnames_service"
            commit network
		EOF
    fi

    ubus call network reload
    return
}

add_wan() {
    local wan_port="$1"
    local wan_ifname="$2"
    local section_name=""
    local list_ports_service=""
    local list_ifnames_bridge=""

    [ "$ENABLE" != "1" ] || [ -z "$PORTS" ] || [ "$VID" = "-1" ] && return
    [ -z "$wan_ifname" ] && return

    if [ "$VID" = "0" ]; then
        # bridge mode
        list_ifnames_bridge=$(uci -q get network.internet.ifname)
        [ -z "$list_ifnames_bridge" ] && return

        local wan6_ifname="br-internet"
        local wan6_mode=$(uci -q get ipv6.wan6.mode)
        [ "$wan6_mode" = "passthrough" ] && wan6_ifname="br-lan"

        list_contains list_ifnames_bridge "$wan_ifname" || append list_ifnames_bridge "$wan_ifname"

        if [ "$(uci -q get xiaoqiang.common.NETMODE)" = "lanapmode" ]; then
            uci -q batch <<-EOF
                set network.internet.ifname="$list_ifnames_bridge"
                commit network
			EOF
        else
            uci -q batch <<-EOF
                set network.internet.ifname="$list_ifnames_bridge"
                set network.wan.ifname="br-internet"
                set network.wan6.ifname="$wan6_ifname"
                commit network
			EOF
            util_portmap_set "$(port_map config get "$wan_port" phy_id)" "br-internet"
        fi

        util_iface_status_set "$wan_ifname" "up"
        ubus call network reload
        reload_firewall
    else
        # media mode
        list_ifnames_bridge=$(uci -q get network."$SERVICE".ifname)
        [ -z "$list_ifnames_bridge" ] && return

        wan_ifname=$(echo "$wan_ifname" | grep -E -o 'eth[0-9]+(\.[0-9]+)?')
        [ -z "$wan_ifname" ] && return
        wan_ifname="$wan_ifname"".$VID"

        list_contains list_ifnames_bridge "$wan_ifname" || append list_ifnames_bridge "$wan_ifname"
        section_name=${wan_ifname//./_}
        section_name="${SERVICE}_${section_name}"
        uci batch <<-EOF
            set network."$section_name"='interface'
            set network."$section_name".ifname="$wan_ifname"
            set network."$section_name".force_link='1'
            set network."$SERVICE".ifname="$list_ifnames_bridge"
            commit network
		EOF
        ubus call network reload

        # sleep 1
        [ "$PRI" != "-1" ] && {
            vconfig set_egress_map "$wan_ifname" 0 "$PRI"
            vconfig set_ingress_map "$wan_ifname" 0 "$PRI"
        }
    fi

    list_ports_service=$(port_map port service "$SERVICE")
    [ -n "$list_ports_service" ] && phyhelper restart "$list_ports_service"
    [ -e /sys/kernel/debug/hnat/iptv_brif ] && echo "$wan_ifname" > /sys/kernel/debug/hnat/iptv_brif
    return
}

del_wan() {
    local ifname=""
    local wan_port="$1"
    local wan_ifname="$2"
    local wan_service_ifname=""
    local service=""
    local list_ifnames_service=""
    local list_ports_service=""

    [ -z "$wan_ifname" ] && return

    for port in $PORTS
    do
        ifname=$(port_map config get "$port" ifname)
        append list_ifnames_service "$ifname"
    done

    [ "$VID" = "0" ] && service="internet" || service="$SERVICE"

    wan_service_ifname=$(echo "$wan_ifname" | grep -E -o 'eth[0-9]+(\.[0-9]+)?')
    wan_service_ifname="$wan_service_ifname"".$VID"

    if [ "$(uci -q get xiaoqiang.common.NETMODE)" = "lanapmode" ]; then
        uci -q batch <<-EOF
            del network."${SERVICE}_${wan_service_ifname//./_}"
            set network."$service".ifname="$list_ifnames_service"
            commit network
		EOF
    else
        uci -q batch <<-EOF
            del network."${SERVICE}_${wan_service_ifname//./_}"
            set network.wan.ifname="$wan_ifname"
            set network.wan6.ifname="$wan_ifname"
            set network."$service".ifname="$list_ifnames_service"
            commit network
		EOF
    fi

    util_portmap_set "$(port_map config get "$wan_port" phy_id)" "$wan_ifname"
    ubus call network reload
    reload_firewall

    list_ports_service=$(port_map port service "$SERVICE")
    [ -n "$list_ports_service" ] && phyhelper restart "$list_ports_service"
    return
}

stop() {
    local ifname list_ifnames section_name

    # clean vlan interface
    list_ifnames=$(uci -q get network.$SERVICE.ifname)
    for ifname in $list_ifnames; do
        section_name=${ifname//./_}
        section_name="${SERVICE}_${section_name}"
        uci -q batch <<-EOF
            del network.$section_name
            commit network
		EOF
    done

    # clean the br-iptv and br-internet
    uci -q batch <<-EOF
        del network.$SERVICE
        del network.internet
        commit network
	EOF
    return
}

reload_firewall() {
    local port=""
    local wan_ifname=""
    local enable_br_netfilter=""
    local rule_name="$SERVICE""_bridge"

    # clean all vlan_bridge rules
    iptables -w -t nat -F "$rule_name" 2>/dev/null
    iptables -w -t nat -D postrouting_rule -j "$rule_name" 2>/dev/null
    iptables -w -t nat -X "$rule_name" 2>/dev/null

    # judge if need to add rules
    [ "$ENABLE" != "1" ] || [ "$VID" != "0" ] && return

    enable_br_netfilter=$(cat /proc/sys/net/bridge/bridge-nf-call-iptables)
    [ "$enable_br_netfilter" != "1" ] && return

    wan_ifname=$(uci -q get network.wan.ifname)
    [ "$wan_ifname" != "br-internet" ] && return

    # add new rules
    iptables -w -t nat -N "$rule_name" 2>/dev/null
    iptables -w -t nat -I postrouting_rule -j "$rule_name" 2>/dev/null
    for port in $PORTS; do
        ifname=$(port_map config get "$port" ifname)
        [ -n "$ifname" ] && iptables -w -t nat -I "$rule_name" -o br-internet -m physdev --physdev-in "$ifname" -j ACCEPT 2>/dev/null
    done

    return 0
}

# -------- main -------- #
[ "$SERVICE" != "iptv" ] && [ "$SERVICE" != "voip" ] && return
case "$CMD" in
    "start")
        start
        ;;
    "stop")
        stop
        ;;
    "restart")
        stop
        start
        ;;
    "add_wan")
        add_wan "$3" "$4"
        ;;
    "del_wan")
        del_wan "$3" "$4"
        ;;
    "reload_firewall")
        reload_firewall
        ;;
    *)
        ;;
esac
return 0
