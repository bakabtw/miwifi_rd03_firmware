#!/bin/sh

arch_pm_config_interface() {
    local section_name="$1"
    local ifname="$2"

    uci -q get network."$section_name" > /dev/null 2>&1 && return

    uci batch <<-EOF
		set network."$section_name"=interface
		set network."$section_name".ifname="$ifname"
		commit network
	EOF
    return
}

arch_pm_config_switch_vlan() {
    local section_name="$1"
    local switch="$2"
    local port="$3"
    local cpu_port="$4"
    local vid="$5"

    uci -q get network."$section_name" > /dev/null 2>&1 && return

    port="${port} ${cpu_port}t"
    uci batch <<-EOF
		set network."$section_name"="switch_vlan"
		set network."$section_name".device="$switch"
		set network."$section_name".ports="$port"
		set network."$section_name".vlan="$vid"
		set network."$section_name".vid="$vid"
		commit network
	EOF
    return
}

arch_pm_extra_build_interface() {
    config_interface_portmap() {
        local port="$1"
        local ifname phy_id

        config_get ifname "$port" ifname
        config_get phy_id "$port" phy_id
        util_portmap_set "$phy_id" "$ifname"
    }

    config_load port_map
    config_foreach config_interface_portmap port
    return
}