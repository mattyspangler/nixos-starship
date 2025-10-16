#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only
# Copyright 2022 Sxmo Contributors
# title="$icon_glb Web Search"
# include common definitions
# shellcheck source=scripts/core/sxmo_common.sh
. sxmo_common.sh

search(){
	if [ -f "$XDG_CONFIG_HOME"/sxmo/bookmarks.tsv ]; then
		options="Bookmarks
Firefox Bookmarks
Close Menu"
	else
		options="Firefox Bookmarks
Close Menu"
	fi
	SEARCHQUERY="$(echo -e "$options" | sxmo_dmenu_with_kb.sh -p "Search:")" || exit 0


	case "$SEARCHQUERY" in
		"Close Menu") exit 0 ;;
		"Bookmarks") bookmarks ;;
		"Firefox Bookmarks") firefox_bookmarks ;;
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

firefox_bookmarks() {
    # Find the places.sqlite file.
    # This might be slow if your home directory is large.
    PLACES_DB=$(find "$HOME/.var/app/org.mozilla.firefox/.mozilla/firefox/" -name "places.sqlite" -print -quit)

    if [ -z "$PLACES_DB" ]; then
        sxmo_notification.sh "Firefox places.sqlite not found."
        exit 1
    fi

    # Query the database for bookmarks, excluding those in the "menu" and "toolbar" folders.
    BOOKMARKS=$(sqlite3 -separator ' | ' "$PLACES_DB" "SELECT p.title, p.url FROM moz_bookmarks b JOIN moz_places p ON b.fk = p.id WHERE b.type = 1 AND b.title IS NOT NULL AND b.parent NOT IN (2, 3) ORDER BY b.dateAdded DESC;")

    if [ -z "$BOOKMARKS" ]; then
        sxmo_notification.sh "No Firefox bookmarks found."
        exit 1
    fi

    # Show the bookmarks in dmenu.
    SELECTED_BOOKMARK=$(echo "$BOOKMARKS" | sxmo_dmenu.sh -p "Firefox Bookmarks")


    if [ -n "$SELECTED_BOOKMARK" ]; then
        # Extract the URL from the selected bookmark string
        SELECTED_URL=$(echo "$SELECTED_BOOKMARK" | awk -F ' | ' '{print $NF}')
        sxmo_urlhandler.sh "$SELECTED_URL"
    fi
}

# Execution
search