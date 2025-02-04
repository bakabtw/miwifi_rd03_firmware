#!/bin/ash

readonly UNBOUND_CB="/etc/miio/unbound.d"

gMethod=
gParams=

[ -f "/etc/miio_spec/init.sh" ] && . /etc/miio_spec/init.sh

usage() {
	cat <<-EOF
		Usage: $0 OPTION...
		MIIO Spec data process

		  -m      method name
		  -p      params data
	EOF
}

while getopts "m:p:h" opt; do
	case "${opt}" in
	m)
		gMethod=${OPTARG}
		;;
	p)
		gParams=${OPTARG}
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
shift $((OPTIND - 1))

if [ -z "$gMethod" ]; then
	printf "Method not specified!\n" >&2
	exit 2
fi

case "$gMethod" in
"get_properties"|"set_properties"|"action")
	"$gMethod" "$gParams"
	;;
"miIO.restore")
	# Delete token and local config
	uci delete miio_ot.ot.token
	uci delete miio_ot.ot.bound
	uci commit miio_ot
	rm -rf /data/miio_ot/config.db

	if [ -d "$UNBOUND_CB" ]; then
		find "$UNBOUND_CB" -type f -exec sh -c 'sh $1 &' _ {} \;
	fi

	# Notify miio_client to restart to regen token
	pgrep miio_client | xargs kill -9
	echo '{}'
	;;
\?)
	printf "%s not supported!\n" "$gMethod" >&2
	exit 3
	;;
esac
