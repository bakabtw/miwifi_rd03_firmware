#!/bin/sh


ntp_sync() {
    sleep 10
    ubus call wan_check reset
    return
}

xqled_reconfig() {
    uci -q batch <<-EOF
        set xqled.sys_ok.action="sys_blue_on sys_yellow_off"
        set xqled.meshing.action="sys_yellow_off sys_blue_flash_fast"
        commit xqled
	EOF

    /etc/init.d/xqled restart
    while true; do
        ubus list led_service 2>/dev/null >/dev/null && break;
        sleep 1
    done

    xqled sys_ok
    return
}

ipv6_auto_check() {
    local wan6_iface_list

    wan6_iface_list=$(uci -q show  ipv6 | grep "ipv6.wan6[_0-9]*.automode='1'" | awk -F"[.|=]" '{print $2}' | xargs echo -n)
    for wan6_iface in $wan6_iface_list; do
        /usr/sbin/ipv6.sh autocheck "$wan6_iface" up &
    done
}


xqled_reconfig &
ntp_sync &
ipv6_auto_check &

