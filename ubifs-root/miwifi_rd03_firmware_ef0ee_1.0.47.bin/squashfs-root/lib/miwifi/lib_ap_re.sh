#!/bin/sh

arch_lanap_open()    { return; }
arch_lanap_close()   { return; }

arch_wifiap_open()  { return; }
arch_wifiap_close() { return; }

arch_whc_re_open()     { return; }
arch_whc_re_close()    { return; }

arch_cpe_bridgemode_open()  { return; }
arch_cpe_bridgemode_close() { return; }

ps_transform_config() { return 0; }
ps_default_config()   { return 0; }

. /lib/miwifi/arch/lib_arch_ap_re.sh
. /lib/miwifi/lib_port_service.sh
. /lib/miwifi/miwifi_functions.sh

################################## static ##################################

_check_wan_proto() {
    [ "pppoe" = "$(uci -q get network.wan.proto)" ] || return
    [ -z "$(uci -q get network.wan.username)" ] && [ -z "$(uci -q get network.wan.password)" ] && {
        uci set network.wan.proto="dhcp"
        uci commit network
    }
}


################################## export ##################################

wifiap_open() {
    util_log "=== wifiap open ==="
    _check_wan_proto
    ps_transform_config ap
    arch_wifiap_open
    return
}

wifiap_close() {
    util_log "=== wifiap close ==="
    ps_transform_config router
    arch_wifiap_close
    return
}

lanap_open() {
    util_log "=== bridgeap open ==="
    _check_wan_proto
    ps_transform_config ap
    arch_lanap_open
    return
}

lanap_close() {
    util_log "=== bridgeap close ==="
    ps_transform_config router
    arch_lanap_close
    return
}

whc_re_open() {
    util_log "=== whc_re open ==="
    _check_wan_proto
    ps_transform_config ap
    arch_whc_re_open
    return
}

whc_re_close() {
    util_log "=== whc_re close ==="
    return
}

cpe_bridgemode_open() {
    util_log "=== cpe bridge mode open ==="
    cp /etc/config/port_service /etc/config/.port_service.router.config
    ps_default_config ap
    arch_cpe_bridgemode_open
    return
}

cpe_bridgemode_close() {
    util_log "=== cpe bridge mode close ==="
    if [ -f "/etc/config/.port_service.router.config" ]; then
        mv /etc/config/.port_service.router.config /etc/config/port_service
    else
        ps_default_config router
    fi

    arch_cpe_bridgemode_close
    return
}
