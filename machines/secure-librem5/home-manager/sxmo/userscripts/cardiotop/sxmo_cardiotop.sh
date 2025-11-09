#!/bin/sh
#
# Main menu for Cardiotop.

# shellcheck source=configs/default_hooks/sxmo_hook_icons.sh
. sxmo_hook_icons.sh
# shellcheck source=scripts/core/sxmo_common.sh
. sxmo_common.sh

set -e

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
# shellcheck source=./_cardiotop_common.sh
. "$SCRIPT_DIR/_cardiotop_common.sh"

# Ensure directory exists
mkdir -p "$PROFILES_DIR"

menu() {
	sxmo_dmenu.sh -i "$@"
}

launch_terminal_menu() {
	# List only enabled profiles
	ENABLED_PROFILES=$(
		find "$PROFILES_DIR" -maxdepth 1 -name "*.json" | while read -r f; do
			printf '%s %s\n' "$icon_run" "$(basename "$f" .json)"
		done
	)

	if [ -z "$ENABLED_PROFILES" ]; then
		printf '%s No enabled Device Profiles found.' "$icon_warn" | menu -p "Info"
		return
	fi

	CHOICE=$(
		{
			printf '%s Back\n' "$icon_bak"
			echo "$ENABLED_PROFILES"
		} |
		menu -p "Launch Device Profile"
	) || return

	case "$CHOICE" in
		""|*"Back")
			return
			;;
		*)
			# Strip icon from choice
			CHOICE_NAME=$(echo "$CHOICE" | cut -d' ' -f2-)
			# Launch the chosen profile in a new terminal
			sxmo_terminal.sh "$SCRIPT_DIR/cardiotop-device" --profile "$PROFILES_DIR/$CHOICE_NAME.json"
			;;
	esac
}

list_profiles_for_manage() {
	# List enabled profiles (ending in .json)
	find "$PROFILES_DIR" -maxdepth 1 -name "*.json" | while read -r f; do
		filename=$(basename "$f" .json)
		printf '%s %s\n' "$icon_don" "$filename"
	done
	# List disabled profiles (ending in .json.disabled)
	find "$PROFILES_DIR" -maxdepth 1 -name "*.json.disabled" | while read -r f; do
		filename=$(basename "$f" .json.disabled)
		printf '%s %s\n' "$icon_dof" "$filename"
	done
}

toggle_profile() {
	PROFILE_LINE="$1"
	STATUS=$(echo "$PROFILE_LINE" | cut -d' ' -f1)
	NAME=$(echo "$PROFILE_LINE" | cut -d' ' -f2-)

	if [ "$STATUS" = "$icon_don" ]; then
		# Disable it by adding .disabled extension
		mv "$PROFILES_DIR/$NAME.json" "$PROFILES_DIR/$NAME.json.disabled"
		sxmo_notify_user.sh "Disabled Device Profile '$NAME'"
	else
		# Enable it by removing .disabled extension
		mv "$PROFILES_DIR/$NAME.json.disabled" "$PROFILES_DIR/$NAME.json"
		sxmo_notify_user.sh "Enabled Device Profile '$NAME'"
	fi
}

manage_profiles_menu() {
	while true; do
		CHOICE=$(
			{
				printf '%s Back\n' "$icon_bak"
				list_profiles_for_manage
				printf '%s Add Device Profile\n' "$icon_plus"
				printf '%s Delete Device Profile\n' "$icon_del"
			} |
			menu -p "Manage Device Profiles"
		) || return

		case "$CHOICE" in
			""|*"Back" )
				return
				;;
			*"Add Device Profile" )
				"$SCRIPT_DIR/cardiotop-add-profile"
				;;
			*"Delete Device Profile" )
				"$SCRIPT_DIR/cardiotop-delete-profile"
				;;
			*)
				toggle_profile "$CHOICE"
				;;
		esac
	done
}

main_menu() {
	while true; do
		CHOICE=$(
			printf '%s Launch Device\n%s Launch Activity\n%s Manage Device Profiles\n%s Close Menu\n' \
				"$icon_run" \
				"$icon_run" \
				"$icon_cfg" \
				"$icon_cls" |
			menu -p "Cardiotop"
		) || exit

		case "$CHOICE" in
			""|*"Close Menu" )
				exit
				;;
			*"Launch Device" )
				launch_terminal_menu
				;;
			*"Launch Activity" )
				sxmo_terminal.sh "$SCRIPT_DIR/cardiotop-activity" --profile default
				;;
			*"Manage Device Profiles" )
				manage_profiles_menu
				;;
		esac
	done
}

main_menu