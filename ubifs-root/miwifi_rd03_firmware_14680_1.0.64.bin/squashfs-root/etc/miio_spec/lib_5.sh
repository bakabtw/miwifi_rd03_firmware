#!/bin/ash

get_5_1() {
	local res=
	res=$(uci -q get xiaoqiang.common.BLUE_LED)

	echo "${res:-1}"
}

set_5_1() {
	local val=$1
	local mod=off

	[ "$val" = true ] && mod=on

	led_ctl "led_$mod"
	led_ctl "led_$mod" ethled
}
