#!/bin/sh
#title="icon_gps macchanger"
#this script changes your mac on wlan
#requirements: macchanger

sudo rfkill block wlan

output=$(sudo macchanger wlan0 -ar)
sleep 1
sudo rfkill unblock wlan

notify-send "done" "$output"

exit