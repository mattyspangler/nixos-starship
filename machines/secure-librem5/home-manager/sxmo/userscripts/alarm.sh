#!/usr/bin/env sh

# To use: edit $ALARM_FILE variable
# Use cron to set your alarm!
# ie: 0 12 * * 1-5 sxmo_rtcwake.sh .config/sxmo/alarm.sh 
# The popup notification will also dismiss the alarm and delete sxmo_mutex files to allow suspend again
# include common definitions
# shellcheck source=scripts/core/sxmo_common.sh
. sxmo_common.sh
# .env_session is the output of a script to collect specific env variables that need to be fed into this script to work
# They are: DBUS_SESSION_BUS_ADDRESS, XDG_RUNTIME_DIR, SXMO_NOTIFDIR, XDG_DATA_HOME, WAYLAND_DISPLAY, and DISPLAY
# This check below covers the only env that changes and would least likely to be fed in
# This file needs to be sourced in the sway config to run on startup and create the env file
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
	. "/tmp/.env_session"
fi
export PATH="/usr/share/sxmo/default_hooks:$PATH"

# Set variables
# If an arguement isn't passed then set default ALARM_FILE
if [ -z "$1" ]; then
	ALARM_FILE="/home/$USER/Music/Alarms/Rain_Alarm.mp3"
else
	ALARM_FILE="$1"
fi
ALARM_VOLUME=35

sxmo_audio.sh vol set "$ALARM_VOLUME"
sxmo_notificationwrite.sh random "pkill -f \"$ALARM_FILE\"; rm -r "$XDG_RUNTIME_DIR/sxmo_mutex/"" none "Alarm running"
mpv --no-resume-playback --loop-file=inf --vid=no "$ALARM_FILE"
