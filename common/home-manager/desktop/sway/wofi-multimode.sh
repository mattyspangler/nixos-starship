#!/usr/bin/env bash

option=$(echo -e "Applications\nWindows" | wofi --show dmenu --prompt="Choose Mode:" --width=300 --height=150) --conf wofi-config

if [[ "$option" == "Applications" ]]; then
    wofi --show drun --allow-images
elif [[ "$option" == "Windows" ]]; then
    wofi --show window --allow-images
fi
