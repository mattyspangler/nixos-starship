#!/bin/sh

set -e

PARTITION="/dev/sda1"

echo "Storing LUKS passphrase for ${PARTITION} in secret service..."
echo "Please enter the LUKS passphrase you created for the SD card."
secret-tool store --label='LUKS Passphrase for SD Card' luks-sdcard "${PARTITION}"

echo "Done."