#!/usr/bin/env bash

# Tips for NixOS config management:
# https://nixos-and-flakes.thiscute.world/nixos-with-flakes/other-useful-tips#managing-the-configuration-with-git

# Require script to be run as sudo:
SUDO_USER=$(sh -c 'echo $SUDO_USER')
echo "The sudo user is $SUDO_USER"
if [ "$SUDO_USER" = "" ]; then echo "This script must be run as sudo"; exit; fi

home_dir=$(eval echo ~$SUDO_USER)
echo "The sudo user home is $home_dir"

echo "Backing up old backup (/etc/nixos.bak.old)"
mv /etc/nixos.bak /etc/nixos.bak.old

echo "Backing up old config (/etc/nixos.bak)"
mv /etc/nixos /etc/nixos.bak

echo "Removing old backup (/etc/nixos.bak.old)"
rm -rf /etc/nixos.bak.old

echo "Moving current config to /etc/nixos" 
cp -r $home_dir/nixos-starship /etc/nixos

echo "Rebuilding and switching to new config"
nixos-rebuild switch --flake $home_dir/nixos-starship/#gaming-desktop --option binary-caches-parallel-connections 5

# Delete all historical versions older than 7 days | EDIT: commented out because I do this in my configs now
#sudo nix profile wipe-history --older-than 7d --profile /nix/var/nix/profiles/system

# Run garbage collection after wiping history
#sudo nix-collect-garbage --delete-old
