#!/usr/bin/env bash

# Simple keymap popup using swaybg
KEYMAP_IMAGE="$HOME/.config/sway/cheatsheet/keymap.png"
LOCK_FILE="/tmp/keymap-popup-active"

# Clean up any existing keymap display
cleanup() {
    if [ -f "$LOCK_FILE" ]; then
        # Restore original wallpaper
        swaymsg "output * bg ~/wallpaper.jpg fill"
        rm -f "$LOCK_FILE"
    fi
    exit 0
}

# Set up cleanup on script exit
trap cleanup EXIT INT TERM

# Create lock file
touch "$LOCK_FILE"

# Show keymap as background
swaymsg "output * bg $KEYMAP_IMAGE fill"

# Wait until interrupted (key released)
while [ -f "$LOCK_FILE" ]; do
    sleep 0.1
done