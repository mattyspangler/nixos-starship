#!/bin/sh
# Simple script that let's you select the scale factor of the device's
# display.
#
# License: MIT

menu() {
	# TODO: export WVKBD_LAYERS to a number layout when one exists.
	SCALEINPUT="$(
	echo "
		2
		1.75
		1.5
		1.25
		1
		Close Menu
	" | awk 'NF' | awk '{$1=$1};1' | sxmo_dmenu_with_kb.sh -p Select scale factor
	)"
	[ "Close Menu" = "$SCALEINPUT" ] && exit 0

	case "$SXMO_WM" in
		sway)
			swaymsg "output \"DSI-1\" scale $SCALEINPUT"
			;;
		*)
			notify-send "Scale Display only supports sway."
			exit 1
			;;
	esac
}

menu
