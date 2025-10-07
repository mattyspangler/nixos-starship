# LUKS-Encrypted SD Card Setup for Librem 5 with postmarketOS

This guide explains how to set up an encrypted SD card that automatically unlocks at boot on a Librem 5 running postmarketOS.

## Overview

This setup uses:
- LUKS encryption for the SD card
- A key file stored on the root filesystem for automatic unlocking
- Standard Linux `/etc/crypttab` and `/etc/fstab` for mounting at boot
- A dedicated mount point at `/run/media/nebula/SDCARD`
- A special directory for Flatpak installations at `/run/media/nebula/SDCARD/flatpak`

## Step 1: Prepare the SD Card

First, identify your SD card device. It's typically `/dev/sda` or `/dev/mmcblk0`:

```bash
lsblk
```

For this guide, we'll assume it's `/dev/sda`.

### Create a partition

```bash
sudo fdisk /dev/sda
```

- Press `n` to create a new partition
- Accept the defaults for partition number and first sector
- Accept the default for the last sector to use the entire card
- Press `w` to write changes and exit

## Step 2: Set up LUKS Encryption

Encrypt the partition:

```bash
sudo cryptsetup luksFormat /dev/sda1
```

This will prompt for a passphrase. Remember this passphrase as you'll need it for recovery.

## Step 3: Create a Key File for Auto-Unlocking

```bash
# Create a directory for the key file
sudo mkdir -p /etc/luks-keys

# Generate a random key file
sudo dd if=/dev/urandom of=/etc/luks-keys/sdcard.key bs=512 count=4

# Secure the key file
sudo chmod 400 /etc/luks-keys/sdcard.key
```

## Step 4: Add the Key File to LUKS

```bash
# Open the encrypted partition with your passphrase
sudo cryptsetup luksOpen /dev/sda1 sdcard_luks

# Add the key file as an additional unlock method
sudo cryptsetup luksAddKey /dev/sda1 /etc/luks-keys/sdcard.key
```

## Step 5: Format the Encrypted Partition

```bash
# Create an ext4 filesystem
sudo mkfs.ext4 /dev/mapper/sdcard_luks

# Create the mount point
sudo mkdir -p /run/media/nebula/SDCARD
```

## Step 6: Configure Auto-Unlocking at Boot

Get the UUID of your SD card partition:

```bash
sudo blkid /dev/sda1
```

Edit the crypttab file:

```bash
sudo nano /etc/crypttab
```

Add this line (replace UUID with your actual UUID):

```
sdcard_luks UUID=YOUR-UUID-HERE /etc/luks-keys/sdcard.key luks
```

## Step 7: Configure Auto-Mounting at Boot

Edit the fstab file:

```bash
sudo nano /etc/fstab
```

Add this line:

```
/dev/mapper/sdcard_luks  /run/media/nebula/SDCARD  ext4  defaults,nofail  0  2
```

The `nofail` option ensures the system will boot even if the SD card is not present.

## Step 8: Create Flatpak Directory

```bash
sudo mkdir -p /run/media/nebula/SDCARD/flatpak
sudo chown nebula:nebula /run/media/nebula/SDCARD/flatpak
```

## Step 9: Test the Setup

Test without rebooting:

```bash
# Close everything first if it's already mounted
sudo umount /run/media/nebula/SDCARD || true
sudo cryptsetup luksClose sdcard_luks || true

# Test the crypttab entry
sudo cryptdisks_start sdcard_luks

# Test the fstab entry
sudo mount /run/media/nebula/SDCARD
```

## Verifying the Setup

After rebooting, the SD card should be automatically unlocked and mounted. Verify with:

```bash
lsblk
df -h /run/media/nebula/SDCARD
```

## Flatpak Configuration

To use the SD card for Flatpak storage:

```bash
flatpak --installation=default config --set-default-repo /run/media/nebula/SDCARD/flatpak
```

## Recovery

If you need to access the SD card on another system:

1. Connect the SD card to the other system
2. Unlock the LUKS container with:
   ```bash
   sudo cryptsetup luksOpen /dev/sdX1 sdcard_luks
   ```
3. Mount the filesystem:
   ```bash
   sudo mount /dev/mapper/sdcard_luks /mnt
   ```

## Backing Up LUKS Headers

It's a good practice to back up your LUKS headers in case of corruption:

```bash
sudo cryptsetup luksHeaderBackup /dev/sda1 --header-backup-file ~/sdcard-luks-header-backup
```

Store this backup file securely, separate from the SD card itself.

## Security Considerations

- This setup automatically unlocks the SD card at boot
- The security of the encrypted data depends on the security of the root filesystem where the key file is stored
- For maximum security, consider using a passphrase instead of a key file, but this will require manual unlocking after each boot

## Troubleshooting

If the SD card doesn't unlock at boot:

1. Check that the UUID in `/etc/crypttab` matches the actual UUID:
   ```bash
   sudo blkid /dev/sda1
   cat /etc/crypttab
   ```

2. Verify the key file exists and has proper permissions:
   ```bash
   ls -la /etc/luks-keys/sdcard.key
   ```

3. Try unlocking manually:
   ```bash
   sudo cryptsetup luksOpen /dev/sda1 sdcard_luks --key-file /etc/luks-keys/sdcard.key
   ```