#!/bin/bash
# title="$icon_tof SSH enable"
# Description: Toggles ssh on or off
# Author: magdesign
# License: MIT
# Note: v0.1 Needs a fix with symbol change state!
# shellcheck source=scripts/core/sxmo_common.sh
. "/usr/bin/sxmo_common.sh"

# check the sshd status
service_status=$(rc-service sshd status)
# path of this script, to toggle name & icon
path_of_script=~/.config/sxmo/userscripts/ssh_toggle.sh

if [[ $service_status == *"started"* ]]; then
    echo "Service sshd is started. Stopping now..."
    # asking for privileges and disabling ssh
    sxmo_terminal.sh -t "Enter password" -- sh -c 'sudo rc-service sshd stop && sudo rc-update del sshd'
    # notify that service is stopping
    notify-send "SSH stopped"
     # change the toggle symbol and name of this script
    sed -i 's/^# title="\$icon_ton SSH disable"/# title="\$icon_tof SSH enable"/' $path_of_script

elif [[ $service_status == *"stopped"* ]]; then
    echo "Service sshd is stopped. Starting now..."
    # asking for privileges and enabling ssh
    sxmo_terminal.sh -t "Enter password" -- sh -c 'sudo rc-service sshd start && sudo rc-update add sshd'
    # notify that it is starting
    notify-send "SSH started"
    # change the toggle symbol and name of this script
    sed -i 's/^# title="\$icon_tof SSH enable"/# title="\$icon_ton SSH disable"/' $path_of_script

else
    notify-send --urgency=critical "Error: no status"
fi
