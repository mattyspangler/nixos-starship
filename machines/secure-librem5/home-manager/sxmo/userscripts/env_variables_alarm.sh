#!/bin/sh
# This script needs to be called by sway at boot to save the 
# env variables needed for the alarm.sh script to work.
# The main one that isn't easy to source is DBUS as this
# changes every boot.
# Change the location of ENV_FILE to suit but make sure you update
# the location of the .env_session file in alarm.sh
# Add the following to .config/sxmo/sway:
# exec "/home/$USER/.config/sxmo/env_variables_alarm.sh"

ENV_FILE="/tmp/.env_session"
DBUS="$(env | grep DBUS_SESSION_BUS_ADDRESS)"
RUNTIME="$(env | grep XDG_RUNTIME_DIR)"
NOTIFDIR="$(env | grep SXMO_NOTIFDIR)"
DATA="$(env | grep XDG_DATA_HOME)"
DISPLAY="$(env | grep DISPLAY)"

echo "export $DBUS" > "$ENV_FILE"
echo "export $RUNTIME" >> "$ENV_FILE"
echo "export $NOTIFDIR" >> "$ENV_FILE"
echo "export $DATA" >> "$ENV_FILE"
echo "export $DISPLAY" >> "$ENV_FILE"
