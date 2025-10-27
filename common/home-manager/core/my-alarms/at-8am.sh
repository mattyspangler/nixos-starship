#!/bin/sh
echo "mpv ~/.config/my-alarms/no-way.flac" | at 08:00
notify-send "Alarm set for 8:00 AM" | at 8:00