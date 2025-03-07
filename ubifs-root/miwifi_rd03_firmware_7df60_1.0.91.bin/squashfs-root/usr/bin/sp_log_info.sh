#!/bin/ash

readonly INSTANT_LOG="/tmp/stat_points/rom.log"
readonly INSTANT_KW="stat_points_instant"

dTag="sp_lib"
dMod="local1.info"
gMod=$dMod
gKey=
gMsg=
gIns=

usage() {
	cat <<-EOF
		Usage: $0 OPTION...
		log stat points msg.

		  -k      message keyword
		  -m      message payload
		  -p      use period mode instead event mode
		  -i      instant mode, ignore message convert and upload directly
	EOF
}

while getopts "k:m:pih" opt; do
	case "${opt}" in
	k)
		gKey=${OPTARG}
		;;
	m)
		gMsg=${OPTARG}
		;;
	p)
		gMod="local2.info"
		;;
	i)
		gIns=1
		;;
	h)
		usage
		exit
		;;
	\?)
		usage >&2
		exit 1
		;;
	esac
done
shift $((OPTIND-1))

if [ -z "$gKey" ] || [ -z "$gMsg" ]; then
	exit 2
fi

if [ -z "$gIns" ]; then
	logger -p "$gMod" -t "$dTag" "$gKey=$gMsg"
else
	mkdir -p "${INSTANT_LOG%/*}"
	echo "$INSTANT_KW $gKey=$gMsg"|tee -a "$INSTANT_LOG" >/dev/null
fi
