#!/usr/bin/env bash

TIMEOUT=${TIMEOUT:-900} # seconds
TERM_EMULATOR=sxmo_terminal.sh

# Wait for secret service to be unlocked
counter=0
while [[ "$(busctl --user get-property org.freedesktop.secrets /org/freedesktop/secrets org.freedesktop.Secret.Service Locked)" != "b false" ]]; do
  sleep 1
  counter=$((counter + 1))
  if [ $counter -ge "$TIMEOUT" ]; then
    exit 1
  fi
done

swaymsg "workspace 1; exec $TERM_EMULATOR -e flatpak run de.schmidhuberj.Flare"
swaymsg "workspace 1; exec $TERM_EMULATOR -e flatpak run im.nheko.Nheko"
swaymsg "workspace 1; exec $TERM_EMULATOR -e flatpak run org.gnome.Calls"