#!/bin/ash

log_exec() {
	echo "========== $1"
	eval "$1"
}

list="0 1"
if ifconfig wl14 >/dev/null 2>&1; then
	list="$list 14"
fi
if ifconfig wl15 >/dev/null 2>&1; then
	list="$list 15"
fi
if ifconfig wl2 >/dev/null 2>&1; then
	list="$list 2"
fi

easymesh_support=$(mesh_cmd easymesh_support)
if [ "$easymesh_support" = "1" ]; then
	easymesh_role=$(uci -q get xiaoqiang.common.EASYMESH_ROLE)
	if [ "$easymesh_role" = "controller" ] \
			|| [ "$easymesh_role" = "agent" ]; then
		easymesh_configured=1
	fi
fi

netmode=$(uci -q get xiaoqiang.common.NETMODE)
if [ "$netmode" = "whc_cap" ] \
		|| [ "$netmode" = "whc_re" ] \
		|| [ "$easymesh_configured" = "1" ]; then

	bh_radio_list="2g 5g 5gh"
	for bh_radio in $bh_radio_list; do
		bh_vap_if=$(uci -q get "misc.backhauls.backhaul_${bh_radio}_ap_iface")
		[ -z "$bh_vap_if" ] && continue

		bh_sta_if=$(uci -q get "misc.backhauls.backhaul_${bh_radio}_sta_iface")
		[ -z "$bh_sta_if" ] && continue

		if echo "${bh_vap_if:-wl}"|grep -qsvxE 'wl[0-2]'; then
			bh_vap_if=$(echo "$bh_vap_if" | cut -d l -f 2)
			bh_vap_list="$bh_vap_list $bh_vap_if"
		fi

		if [ -n "$bh_sta_if" ]; then
			bh_sta_list="$bh_sta_list $bh_sta_if"
		fi
	done

	list="$list $bh_vap_list"
fi

echo "========== list:$list"
for i in $list; do
	echo "wl$i"
	log_exec "iwinfo wl$i info"
	log_exec "iwinfo wl$i assolist"
	log_exec "iwinfo wl$i txpowerlist"
	log_exec "iwinfo wl$i freqlist"
	log_exec "iwpriv wl$i show stainfo"
	log_exec "iwconfig wl$i"
	log_exec "iwpriv wl$i show chutil"
	log_exec "iwpriv wl$i show swqinfo"
	log_exec "iwpriv wl$i show trinfo"

	if [ $i = 0 ]; then
		log_exec "iwpriv wl$i show ser"
	fi
done

if [ "$netmode" = "whc_re" ] \
		|| [ "$easymesh_role" = "agent" ] \
		&& [ -n "$bh_sta_list" ]; then

	echo "========== bh_sta_list:$bh_sta_list"
	for i in $bh_sta_list; do
		echo "========== @@@@ iwinfo $i @@@@"
		log_exec "iwinfo $i info"
		log_exec "iwconfig $i"
		log_exec "iwpriv $i Connstatus"
	done
fi
