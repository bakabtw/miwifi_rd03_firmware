#!/bin/sh

arch_whc_re_open() {
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

arch_whc_re_close() {
    # mesh4.0
    local inittd mesh_suite support_meshv4

    inittd="$(uci -q get xiaoqiang.common.INITTED)"
    mesh_suite="$(mesh_cmd mesh_suites >&2)"
    support_meshv4="$(mesh_cmd support_mesh_version 4)"

    if [ "$inittd" = "YES" ] && [ "$support_meshv4" = "1" ]; then
        if [ "$mesh_suite" -gt "0" ]; then
            /usr/sbin/mesh_connect.sh init_cap 2
        else
            /usr/sbin/mesh_connect.sh init_mesh_hop 0
        fi
    fi
}