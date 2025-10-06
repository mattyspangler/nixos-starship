#!/bin/sh

set -e

DEVICE="/dev/sda"
MAPPER_NAME="sdcard_luks"

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root."
  exit 1
fi

echo "WARNING: This script will wipe all data on ${DEVICE}."
read -p "Are you sure you want to continue? (y/N) " -r
echo
if ! [ "$REPLY" = "y" ]; then
    echo "Aborting."
    exit 0
fi

echo "Unmounting partitions on ${DEVICE}..."
umount "${DEVICE}"* || true

echo "Creating new GPT partition table on ${DEVICE}..."
parted -s "${DEVICE}" -- mklabel gpt
parted -s -a optimal "${DEVICE}" -- mkpart primary ext4 1MiB 100%

# It might take a moment for the new partition to show up
sleep 2
PARTITION="${DEVICE}1"

echo "Formatting ${PARTITION} with LUKS..."
cryptsetup luksFormat "${PARTITION}"

echo "Opening LUKS container..."
cryptsetup luksOpen "${PARTITION}" "${MAPPER_NAME}"

echo "Creating ext4 filesystem on /dev/mapper/${MAPPER_NAME}..."
mkfs.ext4 "/dev/mapper/${MAPPER_NAME}"

echo "Closing LUKS container..."
cryptsetup luksClose "${MAPPER_NAME}"

echo "Done. You can now run the store-sd-card-secret.sh script to store the passphrase."
