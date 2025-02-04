#!/bin/sh


arch_pm_config_interface()      { return 0; }
arch_pm_config_switch_vlan()    { return 0; }
arch_pm_extra_clean_interface() { return 0; }
arch_pm_extra_build_interface() { return 0; }
arch_pm_extra_rebuild_network() { return 0; }
[ -f "/lib/miwifi/arch/lib_arch_port_map.sh" ] && . /lib/miwifi/arch/lib_arch_port_map.sh

pm_config_interface() {
    arch_pm_config_interface "$@"
    return
}

pm_config_switch_vlan() {
    arch_pm_config_switch_vlan "$@"
    return
}

pm_extra_clean_interface() {
    arch_pm_extra_clean_interface "$@"
    return
}

pm_extra_build_interface() {
    arch_pm_extra_build_interface "$@"
    return
}

pm_extra_rebuild_network() {
    arch_pm_extra_rebuild_network "$@"
    return
}