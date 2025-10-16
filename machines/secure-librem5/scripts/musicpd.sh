#!/usr/bin/env sh
# shellcheck disable=SC2154

# shellcheck disable=SC1090
. "$(which sxmo_common.sh)"
# shellcheck disable=SC1090
. "$(which sxmo_icons.sh)"

prompt() {
	sxmo_dmenu.sh -i "$@"
}

show_toggle() {
	if [ -n "$1" ]; then
		printf %s "$icon_ton"
	else
		printf %s "$icon_tof"
	fi
}

set -e

loadmarkers() {
	if ! MPC="$(mpc)"; then
		MARKERS="disconnected"
		return
	fi

	repeat="$(printf %s "$MPC" | grep -qF "repeat: on" && printf "r" || printf "" )"
	random="$(printf %s "$MPC" | grep -qF "random: on" && printf "z" || printf "" )"
	single="$(printf %s "$MPC" | grep -qF "single: on" && printf "s" || printf "" )"
	consume="$(printf %s "$MPC" | grep -qF "consume: on" && printf "c" || printf "" )"
	MARKERS="[$repeat$random$single$consume]"
}

playlistloop() {
	while true ;
	do
		PLAYING="$(mpc current)"
		PLAYLISTCHOICES="$(mpc playlist)"

		if [ -n "$PLAYING" ]; then
			INDEX="$(printf %s "$PLAYLISTCHOICES" | grep -n "$PLAYING" | cut -d: -f1)"
		fi

		PLAYLISTPICKED="$(
			printf %s "$PLAYLISTCHOICES" |
			xargs -0 printf "$icon_ret Return\n%s" |
			prompt -p "Playlist" ${INDEX:+-I "$INDEX"}
		)"

		case "$PLAYLISTPICKED" in
			"$icon_ret Return")
				break
				;;
			*)
				printf "%s\n" "$PLAYLISTPICKED" \
					| awk -F " - " '{ print $2 }' \
					| xargs -I{} mpc searchplay title "{}"
				;;
		esac
	done
}

browseloop() {
	INDEX=0
	while true; do
		BROWSECHOICES="$(cat <<EOF | sort
$(mpc -f "%artist%/%album%" listall | grep -v "^/$" | sort | uniq)
$(mpc list Artist | grep . | tr '\n' '\0' | xargs -0 printf "%s/\n")
EOF
)"

		BROWSEPICKED="$(
			printf "%s\n" "$BROWSECHOICES" |
			xargs -0 printf "$icon_ret Return\n%s" |
			prompt -p "Browse" -I "$INDEX"
		)"

		case "$BROWSEPICKED" in
			"$icon_ret Return")
				break
				;;
			*/)
				mpc findadd "artist" "${BROWSEPICKED%/*}"
				;;
			*)
				mpc findadd "album" "${BROWSEPICKED#*/}"
				;;
		esac

		INDEX="$(printf "%s\n" "$BROWSECHOICES" | grep -n "^$BROWSEPICKED$" | head -n+1 | cut -d: -f1)"
	done
}

optionloop() {
	INDEX=0
	while true; do
		loadmarkers

		OPTIONCHOICES="$(cat <<EOF
$icon_ret Return
$icon_rol Repeat $(show_toggle "$repeat") ^ mpc repeat
$icon_ror Single $(show_toggle "$single") ^ mpc single
$icon_sfl Random $(show_toggle "$random") ^ mpc random
$icon_shr Consume $(show_toggle "$consume") ^ mpc consume
EOF
)"

		OPTIONPICKED="$(
			printf "%s\n" "$OPTIONCHOICES" |
			cut -d'^' -f1 |
			prompt -p "Options $MARKERS" -I "$INDEX"
		)"

		case "$OPTIONPICKED" in
			"$icon_ret Return")
				break
				;;
			*)
				CMD="$(
					printf '%b' "$OPTIONCHOICES" |
					grep -m1 -F "$OPTIONPICKED" |
					cut -d'^' -f2 |
					sed '/^[[:space:]]*$/d' |
					awk '{$1=$1};1'
				)"
				sh -c "$CMD"
				;;
		esac

		INDEX="$(($(printf "%s\n" "$OPTIONCHOICES" | grep -n "^$OPTIONPICKED" | head -n+1 | cut -d: -f1) -1))"
	done
}

mpdtoggleline() {
	command -v mpd > /dev/null || return
	pgrep mpd > /dev/null \
		&& printf "%s Stop MPD ^ mpd --kill" "$icon_zzz" \
		|| printf "%s Start MPD ^ mpd" "$icon_pwr"
	printf " && sleep 1"
}

mainloop() {
	INDEX=0
	while true; do
		loadmarkers
		MAINCHOICES="$(cat << EOF
$icon_pau Toggle      ^ mpc toggle
$icon_stp Stop        ^ mpc stop
$icon_nxt Next        ^ mpc next
$icon_prv Previous    ^ mpc prev
$icon_lst Playlist
$icon_dir Browse
$icon_cfg Options
$icon_spk Audio       ^ sxmo_appmenu.sh audioout
$icon_bth Bluetooth   ^ sxmo_bluetoothmenu.sh
$icon_rld Update      ^ mpc update
$icon_cls Clear Queue ^ mpc clear
$(pgrep mpd > /dev/null && printf "%s Stop MPD ^ mpd --kill" "$icon_zzz" || printf "%s Start MPD ^ mpd" "$icon_pwr") && sleep 1
$icon_ret Close Menu
EOF
)"

		MAINPICKED="$(
			printf "%s\n" "$MAINCHOICES" |
			cut -d'^' -f1 |
			prompt -p "Music $MARKERS" -I "$INDEX"
		)"

		case "$MAINPICKED" in
			"$icon_ret Close Menu")
				break
				;;
			"$icon_lst Playlist")
				playlistloop
				;;
			"$icon_dir Browse")
				browseloop
				;;
			"$icon_cfg Options")
				optionloop
				;;
			*)
				CMD="$(
					printf '%b' "$MAINCHOICES" |
					grep -m1 -F "$MAINPICKED" |
					cut -d'^' -f2 |
					sed '/^[[:space:]]*$/d' |
					awk '{$1=$1};1'
				)"
				sh -c "$CMD"
				;;
		esac

		INDEX="$(($(printf "%s\n" "$MAINCHOICES" | grep -n "^$MAINPICKED" | head -n+1 | cut -d: -f1) -1))"
	done
}

mpc update >> /dev/null
mainloop
