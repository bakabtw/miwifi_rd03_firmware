#!/bin/sh

# ""/whc_cap/whc_re/lanapmode/wifiapmode/dmzsimple/dmzmode
PS_UCI="port_service"


arch_ps_init_service()          { return 0; }
arch_ps_pre_stop_service()      { return 0; }
arch_ps_post_stop_service()     { return 0; }
arch_ps_pre_start_service()     { return 0; }
arch_ps_post_start_service()    { return 0; }
arch_ps_clean_config()          { return 0; }
arch_ps_config_interface()      { return 0; }
arch_ps_config_switch_vlan()    { return 0; }
arch_ps_phy_control()           { return 0; }
arch_ps_setup_wan()             { return 0; }
arch_ps_reset_lan()             { return 0; }
arch_ps_default_config()        { return 0; }
arch_ps_rebuild_network()       { return 0; }
arch_ps_reload_firwall_common() { return 0; }
arch_ps_transform_config()      { return 0; }
arch_ps_reset_passthrough()     { return 0; }
arch_ps_check_service()         { return 0; }
. /lib/functions.sh
. /lib/miwifi/miwifi_functions.sh
. /lib/miwifi/arch/lib_arch_port_service.sh


ps_logger() {
    echo -e "[port_service] $*" > /dev/console
    return
}

ps_uci_set() {
    local section="$1"
    local key="$2"
    local value="$3"

    [ -z "$section" ] || [ -z "$key" ] && return

    uci batch <<-EOF
		set "$PS_UCI"."$section"."$key"="$value"
		commit "$PS_UCI"
	EOF
    return
}

ps_uci_get() {
    local section="$1"
    local key="$2"
    local value=""

    [ -z "$section" ] || [ -z "$key" ] && return

    value=$(uci -q get "$PS_UCI"."$section"."$key")
    [ -n "$value" ] && echo "$value"
    return
}

ps_wandt_ctl() {
    local action="$1"
    local script="/usr/sbin/wan_detect.sh"

    [ ! -f "$script" ] || [ -z "$action" ] && return

    "$script" "$@"
    return
}

ps_iptv_ctl() {
    local action="$1"
    local script="/usr/sbin/media.sh"
    local ports

    ports=$(port_map port service "$service")
    [ -z "$ports" ] && return
    [ ! -x "$script" ] || [ -z "$action" ] && return

    "$script" iptv "$@"
    ps_logger "iptv $action finish"
    return
}

ps_media_ctl() {
    local action="$1"
    local script="/usr/sbin/media.sh"
    local service ports
    local list_media_services="iptv"

    [ ! -f "$script" ] || [ -z "$action" ] && return

    for service in $list_media_services; do
        ports=$(port_map port service "$service")
        [ -n "$ports" ] && {
            "$script" "$service" "$@"
            ps_logger "$service $action finish"
        }
    done
    return
}

ps_lag_ctl() {
    local action="$1"
    local script="/usr/sbin/lag.sh"
    local ports

    ports=$(port_map port service lag)
    [ -z "$ports" ] && return

    [ ! -f "$script" ] || [ -z "$action" ] && return

    "$script" "$@"
    ps_logger "lag $action finish"
    return
}

ps_game_ctl() {
    local action="$1"
    local script="/usr/sbin/game.sh"
    local ports

    ports=$(port_map port service game)
    [ -z "$ports" ] && return
    [ ! -x "$script" ] || [ -z "$action" ] && return

    "$script" "$@"
    ps_logger "game $action finish"
    return
}

ps_wan_ctl() {
    local action="$1"
    local enable wandt ports link_mode wandt_ports proto lan_ports type

    wan_start() {
        local service="$1"
        [ "${service:0:3}" = "wan" ] || return

        config_get enable "$service" enable
        [ "$enable" = "1" ] || return

        config_get type "$service" type
        [ "$type" = "eth" ] || return

        config_get ports "$service" ports
        config_get wandt "$service" wandt
        config_get link_mode "$service" link_mode

        # wan detect only used for wan, not wan_2
        [ "$service" != "wan" ] && wandt="0"

        if [ "$wandt" = "1" ]; then
            wandt_ports="${wandt_ports} ${ports}"

            # in wandt mode, wan's link_mode must set to auto
            ps_uci_set wan link_mode 0
            [ "$(uci -q get port_map."${ports}".type)" = "sfp" ] || phyhelper mode set "$ports" 0
            ps_logger "$service start wandt mode finish"
        else
            [ -z "$ports" ] && return

            [ "$(uci -q get port_map."${ports}".type)" = "sfp" ] || phyhelper mode set "$ports" "$link_mode"

            proto=$(uci -q get network."$service".proto)
            ps_setup_wan "$service" "$proto" "$ports"
            ps_logger "$service start fixed mode finish"
        fi
        return
    }

    wan_stop() {
        local service="$1"
        [ "${service:0:3}" = "wan" ] || return

        # check wan type, only for wired wan
        config_get type "$service" type
        [ "$type" = "eth" ] || return

        # check last wan port
        ports=$(port_map port service "$service")
        [ -z "$ports" ] && return

        [ "$(uci -q get port_map."${ports}".type)" = "sfp" ] || phyhelper mode set "$ports" 0
        arch_ps_reset_lan "$service" "$ports"
        ps_logger "$service stop finish"
        return
    }

    config_load "$PS_UCI"
    if [ "$action" = "start" ]; then
        ps_uci_set wandt_attr enable "0"
        config_foreach wan_start service
        if [ -n "$wandt_ports" ]; then
            lan_ports=$(port_map port service lan)
            wandt_ports="${wandt_ports} ${lan_ports}"

            # config and run wan_detect c program
            ps_uci_set wandt_attr ports "$(echo "$wandt_ports"|xargs)"
            ps_uci_set wandt_attr enable "1"
            ps_wandt_ctl start
        else
            ps_wandt_ctl filter unload
        fi
    elif [ "$action" = "stop" ]; then
        ps_wandt_ctl stop

        # avoid lan device get uppper dhcp server's ip, when wan is in wandt mode
        ps_wandt_ctl filter load

        ps_uci_set wandt_attr enable "0"
        config_foreach wan_stop service
    fi
    return
}

ps_init_service() {
    arch_ps_init_service
    return
}

ps_pre_start_service() {
    arch_ps_pre_start_service
    return
}

ps_post_start_service() {
    arch_ps_post_start_service
    return
}

ps_pre_stop_service() {
    arch_ps_pre_stop_service
    return
}

ps_post_stop_service() {
    arch_ps_post_stop_service
    return
}

ps_check_service() {
    arch_ps_check_service "$@"
    return
}

ps_phy_control() {
    local action="$1"

    case "$action" in
    stop)
        phyhelper stop  "$(port_map port class lan)"
        phyhelper start "$(port_map port class wan)"
        ;;
    start)
        phyhelper start
        ;;
    esac
    return
}

ps_rebuild_network() {
    # avoid lan device get uppper dhcp server's ip, when wan is in wandt mode
    [ "1" = "$(ps_uci_get wan wandt)" ] && [ "1" = "$(ps_uci_get wan enable)" ] && ps_wandt_ctl filter load

    arch_ps_rebuild_network
    return
}

ps_setup_wan() {
    local service="$1"
    local proto="$2"
    local wan_port="$3"

    ps_logger "setup $*"

    ps_uci_set "$service" ports "$wan_port"
    port_map config set "$wan_port" service "$service"
    arch_ps_setup_wan "$service" "$proto" "$wan_port"
    return
}

ps_reset_lan() {
    local service="$1"
    local old_wan_port
    old_wan_port=$(port_map port service "$service")
    old_wan_ifname=$(port_map config get "$old_wan_port" ifname)

    [ -z "$old_wan_port" ] && return
    ps_logger "reset lan $old_wan_port"

    ps_uci_set "$service" ports ""
    port_map config set "$old_wan_port" service lan
    arch_ps_reset_lan "$service" "$old_wan_port"
    arch_ps_reset_passthrough "$old_wan_ifname"
    return
}

ps_reload_firewall_arp_intercept() {
    local initted lan_ip lan_mac
    local rule_name="port_service_common"

    # clean all arptables rules
    arptables -F "$rule_name" > /dev/null 2>&1
    arptables -D FORWARD -j "$rule_name" > /dev/null 2>&1
    arptables -X "$rule_name" > /dev/null 2>&1

    # judge if need to add rules
    initted=$(uci -q get xiaoqiang.common.INITTED)
    [ -z "$initted" ] || return

    # if the router uninitted, force all lans only can get his br-lan's macaddr
    lan_ip=$(uci -q get network.lan.ipaddr)
    lan_mac=$(uci -q get network.lan.macaddr)
    [ -n "$lan_ip" ] && [ -n "$lan_mac" ] && {
        arptables -N "$rule_name"
        arptables -I FORWARD -j "$rule_name"
        arptables -I "$rule_name" --h-length 6 --h-type 1 --proto-type 0x800 --opcode 2 -s "$lan_ip" -j mangle --mangle-mac-s "$lan_mac"
    }
    return
}

ps_reload_firewall_common() {
    ps_reload_firewall_arp_intercept
    arch_ps_reload_firwall_common
    return
}

ps_default_config() {
    local mode="$1" # "router" or "ap"

    config_cb() {
        local section_type="$1"
        local service="$2"

        [ "$section_type" != "service" ] && return

        if [ "$service" = "wan" ] && [ "$mode" = "router" ]; then
            uci -q set "$PS_UCI"."$service".enable="1"
            uci -q set "$PS_UCI"."$service".ports=""
            uci -q set "$PS_UCI"."$service".wandt="1"
        else
            uci -q set "$PS_UCI"."$service".enable="0"
            uci -q set "$PS_UCI"."$service".ports=""
        fi
        return
    }

    config_load "$PS_UCI"
    uci commit "$PS_UCI"
    return
}

ps_transform_config() {
    local mode="$1" # "router" or "ap"
    local service ap_services router_services

    ap_services=$(ps_uci_get settings ap_services)
    [ -z "$ap_services" ] && ap_services="lag"
    router_services=$(ps_uci_get settings router_services)
    [ -z "$router_services" ] && router_services="wan wan_2 lag iptv game"

    for service in $router_services; do
        list_contains ap_services "$service" && continue
        case "$mode" in
            "ap") # transform into ap modes
                    uci set "$PS_UCI"."$service".enable="0"
                ;;
            "router") # transform into router modes
                    [ "$service" = "wan" ] && {
                        uci batch <<-EOF
                            set "$PS_UCI".wan.enable=1
                            set "$PS_UCI".wan.wandt=1
                            set "$PS_UCI".wan.ports=""
                            commit "$PS_UCI"
						EOF
                    }
                ;;
        esac
    done
    uci commit "$PS_UCI"

    arch_ps_transform_config "$mode"
    return
}