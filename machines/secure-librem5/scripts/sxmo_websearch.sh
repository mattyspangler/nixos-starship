#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only
# Copyright 2022 Sxmo Contributors
# title="$icon_glb Web Search"
# include common definitions
# shellcheck source=scripts/core/sxmo_common.sh
. sxmo_common.sh

search(){
	if [ -f "$XDG_CONFIG_HOME"/sxmo/bookmarks.tsv ]; then
		SEARCHQUERY="$(echo "Close Menu" | sed 's/^/Bookmarks\n/' | sxmo_dmenu_with_kb.sh -p "Search:")" || exit 0
	else
		SEARCHQUERY="$(echo "Close Menu" | sxmo_dmenu_with_kb.sh -p "Search:")" || exit 0
	fi

	case "$SEARCHQUERY" in
		"Close Menu") exit 0 ;;
		"Bookmarks") bookmarks ;;
		*) $BROWSER "https://duckduckgo.com/?q=${SEARCHQUERY}" ;;
	esac
}

bookmarks(){
	## Web Apps list, use "Type (tab) Name (tab) URL" for list format
	## keeping the " at the end
	WebList=$(cat "$XDG_CONFIG_HOME"/sxmo/bookmarks.tsv)

	## Menu title at top
	Name="Websites"
	Type="$(printf '%s' "$WebList" | cut -f1 | sort -u)"
	
	choice="$(printf '%s' "$Type" | awk '($0){print} END{print "Close Menu"}' | sxmo_dmenu.sh -i -p "$Name")"
	if test "$choice" = "Close Menu"; then
		search
	fi
	list="$(printf '%s' "$WebList" | grep "$choice" | cut -f2 |  awk '($0){print} END{print "Close Menu"}' | sxmo_dmenu.sh -i -p "$choice")"

	case "$list" in
		"Close Menu") bookmarks ;;
		*)
			play="$(printf '%s' "$WebList" | grep "$list" | cut -f3)"
			sxmo_urlhandler.sh "$play" ;;
	esac
}

# Execution
search