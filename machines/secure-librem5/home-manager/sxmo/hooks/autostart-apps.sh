#!/usr/bin/env bash

TIMEOUT=${TIMEOUT:-300} # seconds
TERM_EMULATOR=sxmo_terminal.sh

counter=0
while ! busctl --user exist org.freedesktop.secrets >/dev/null 2>&1; do
  sleep 1
  counter=$((counter + 1))
  if [ $counter -ge "$TIMEOUT" ]; then
    exit 1
  fi
done

swaymsg "workspace 1; exec $TERM_EMULATOR -e flatpak run de.schmidhuberj.Flare"
swaymsg "workspace 2; exec $TERM_EMULATOR -e flatpak run im.nheko.Nheko"
swaymsg "workspace 3; exec $TERM_EMULATOR -e flatpak run org.gnome.Calls"