#!/bin/sh

set -e

# Launch KeePassXC in the background
flatpak run org.keepassxc.KeePassXC &

# Wait for the secret service to become available
while ! secret-tool lookup luks-sdcard /dev/sda1 > /dev/null 2>&1; do
  sleep 1
done

# Mount SD card for Flatpak
if [ -b /dev/sda1 ]; then
  LUKS_PASSWORD=$(secret-tool lookup luks-sdcard /dev/sda1)
  if [ -n "$LUKS_PASSWORD" ]; then
    echo "$LUKS_PASSWORD" | sudo cryptsetup luksOpen /dev/sda1 sdcard_luks --key-file -
    sudo mkdir -p /run/media/nebula/SDCARD
    sudo mount /dev/mapper/sdcard_luks /run/media/nebula/SDCARD || true
    sudo mkdir -p /run/media/nebula/SDCARD/flatpak
  fi
fi