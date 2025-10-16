#!/bin/sh
# Author: Aljoscha Hartmann <aljoscha.hartmann@posteo.de>
# Currently this script doesn't support turning of bluetooth, as I don't use bluetooth myself. Feel free to add a line for bluetooth anytime!
# License GPL3+

# title="$icon_net Airplane Mode"

radio="$(nmcli radio all | awk 'FNR == 2 {print $2}')"
if [ "$radio" == "enabled" ]
 then
  nmcli radio all off
  notify-send "Airplane mode is ON"
else
 nmcli radio all on
 notify-send "Airplane mode is OFF"
fi
