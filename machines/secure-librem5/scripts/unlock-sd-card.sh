#!/bin/sh

set -e

echo "Starting SD card unlock process..."

# Launch KeePassXC in the background
echo "Launching KeePassXC..."
flatpak run org.keepassxc.KeePassXC &

# Wait for the secret service to become available
echo "Waiting for secret service..."
while ! secret-tool lookup luks-sdcard /dev/sda1 > /dev/null 2>&1; do
  sleep 1
done
echo "Secret service available."

# Mount SD card for Flatpak
if [ -b /dev/sda1 ]; then
  echo "Unlocking LUKS container..."
  LUKS_PASSWORD=$(secret-tool lookup luks-sdcard /dev/sda1)
  if [ -n "$LUKS_PASSWORD" ]; then
    echo "$LUKS_PASSWORD" | sudo cryptsetup luksOpen /dev/sda1 sdcard_luks --key-file -
    echo "LUKS container unlocked."

    echo "Mounting SD card..."
    sudo mkdir -p /run/media/nebula/SDCARD
    sudo mount /dev/mapper/sdcard_luks /run/media/nebula/SDCARD || true
    echo "SD card mounted."

    echo "Creating Flatpak directory..."
    sudo mkdir -p /run/media/nebula/SDCARD/flatpak
    echo "Flatpak directory created."
  else
    echo "Could not retrieve LUKS passphrase from secret service."
  fi
else
  echo "/dev/sda1 not found."
fi

echo "SD card unlock process finished."