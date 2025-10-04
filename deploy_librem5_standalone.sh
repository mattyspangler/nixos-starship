#!/usr/bin/env bash
set -e

# This script deploys the home-manager configuration.
# It includes steps for the initial setup of channels, making it suitable for first-time installs.

echo "Setting up nix channels for first-time install (if needed)..."
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update && nix-shell '<home-manager>' -A install

echo "Cleaning old home-manager generations..."
# Clean up home-manager generations older than 3 entries, keeping the last 3.
# The awk script skips the first 3 lines and prints the last field (the generation number) of the rest.
home-manager generations | awk 'NR > 3 {print $NF}' | xargs -r -- home-manager remove-generations

echo "Deploying home-manager configuration via flake..."
home-manager switch --extra-experimental-features 'nix-command flakes' --flake .#nebula@libremfive

echo "Deployment finished successfully."
