#!/bin/sh

arch_ps_rebuild_network() {
    local vid port
    local list_ports_class_wan list_ifname_lan

    list_ports_class_wan=$(port_map port class wan)
    [ -n "$list_ports_class_wan" ] && {
        list_ifname_lan=$(uci -q get network.lan.ifname)
        for port in $list_ports_class_wan; do
            vid=$(port_map config get "$port" vid)
            append list_ifname_lan "eth0.$vid"
        done
        uci set network.lan.ifname="$list_ifname_lan"
        uci commit network
    }

    ubus call network reload
    /etc/init.d/network reconfig_switch
}

arch_ps_check_service() {
    list_contains LIST_SERVICES "wan" || append LIST_SERVICES "wan"
}

arch_ps_post_start_service() {
    [ "whc_re" = "$(uci -q get xiaoqiang.common.NETMODE)" ] && {
        # in re mode, the topomon must restart when user change the lag's config
        /etc/init.d/topomon restart
    }
    util_portmap_update
}

arch_ps_setup_wan() {
    local service="$1"
    local wan_type="$2"
    local wan_port="$3"
    local wan_ifname wan_vid current_wan_type wan_phy
    local wan6_ifname pass_ifname
    local portmap="00000100" # bit5

    # reconfig network ifname
    wan_vid=$(port_map config get "$wan_port" vid)
    wan_phy=$((wan_port - 1))
    wan_ifname="eth1.$wan_vid"

    wan6_ifname="$wan_ifname"
    [ "$(uci -q get network."${service/n/n6}".passthrough)" = "1" ] && {
        wan6_ifname="br-lan"
        pass_ifname="$wan_ifname"
    }

    uci -q batch <<-EOF
        set network."eth1_$wan_vid"=interface
        set network."eth1_$wan_vid".ifname="$wan_ifname"
        set network."$service".ifname="$wan_ifname"
        set network."${service/n/n6}".ifname="$wan_ifname"
        set network."macv_${service/n/n6}".ifname="$wan_ifname"
        set network."${service/n/n6}".ifname="$wan6_ifname"
        set network."${service/n/n6}".pass_ifname="$pass_ifname"
        set network."vlan$wan_vid".ports="$wan_phy 5t"
        commit network
	EOF

    # reconfig network wan type
    current_wan_type=$(uci -q get network."$service".proto)
    [ -n "$wan_type" ] && [ -z "$current_wan_type" ] && {
        uci batch <<-EOF
            set network."$service".proto="$wan_type"
            commit network
		EOF
    }

    # reload network
    util_portmap_set "$wan_phy" "$wan_ifname"
    util_iface_status_set "eth0.$wan_vid" "down" # necessary! for ipv6 passthrough mode
    port_map config set "$wan_port" ifname "$wan_ifname"

    echo "$wan_vid" > /sys/kernel/debug/hnat/wan_vid

    portmap=$(echo "$portmap" | sed "s/./1/$wan_port")
    switch vlan set 0 "$wan_vid" "$portmap" 0 0 00000200
    ubus call network reload
    ubus call network.interface."$service" up

    # reload iptv and voip service
    [ "$service" = "wan" ] && ps_media_ctl add_wan "$wan_port" "$wan_ifname"

    # reload other services
    /etc/init.d/wan_check restart > /dev/null 2>&1
    /etc/init.d/miqos restart  > /dev/null 2>&1
    /etc/init.d/dnsmasq restart > /dev/null 2>&1
    /etc/init.d/messagingagent.sh restart > /dev/null 2>&1
}

arch_ps_reset_lan() {
    local service="$1"
    local old_wan_port="$2"
    local wan_phy lan_ifname
    local portmap="00000010" # bit6

    [ -z "$old_wan_port" ] && return
    wan_vid=$(port_map config get "$old_wan_port" vid)
    wan_phy=$((old_wan_port - 1))
    lan_ifname="eth0.$wan_vid"

    # reload iptv and voip service
    [ "$service" = "wan" ] && ps_media_ctl del_wan "$old_wan_port" "eth1.$wan_vid"

    # reconfig network
    uci -q batch <<-EOF
        delete network."eth1_$wan_vid"
        delete network."$service".ifname
        delete network."${service/n/n6}".ifname
        delete network."${service/n/n6}".pass_ifname
        delete network."macv_${service/n/n6}".ifname
        set network."vlan$wan_vid".ports="$wan_phy 6t"
        commit network
	EOF

    # reload network
    util_portmap_set "$wan_phy" "$lan_ifname"
    port_map config set "$old_wan_port" ifname "$lan_ifname"
    pconfig del "eth1.${wan_vid}_6" > /dev/null 2>&1
    portmap=$(echo "$portmap" | sed "s/./1/$old_wan_port")
    switch vlan set 0 "$wan_vid" "$portmap" 0 0 00000020
    ubus call network.interface."$service" down
    ubus call network reload
    util_portmap_update
    return
}