#!/usr/bin/env bash
set -e

# Change to the script's directory
cd $HOME/nixos-starship

# This script deploys the home-manager configuration.
# It includes steps for the initial setup of channels, making it suitable for first-time installs.

echo "Pulling latest changes from git..."
git pull

echo "Ensuring nix channels are configured..."
# If channels are not configured, add them.
if ! nix-channel --list | grep -q "^nixpkgs " || ! nix-channel --list | grep -q "^home-manager "; then
    echo "One or more channels are missing. Adding them..."
    # Adding 'nixpkgs' as the channel name for clarity and robustness.
    nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
fi

echo "Updating nix channels..."
nix-channel --update && nix-shell '<home-manager>' -A install

if [[ "$1" == "--clean" ]]; then
    echo "Cleaning old home-manager generations..."
    # The awk script skips the first 3 lines and prints the last field (the generation number) of the rest.
    home-manager generations | awk 'NR > 3 {print $NF}' | xargs -r -- home-manager remove-generations > /dev/null

    echo "Doing garbage collection on nix-store"
    nix-store --gc
fi

echo "Deploying home-manager configuration via flake..."
home-manager switch --extra-experimental-features 'nix-command flakes' --flake .#nebula@libremfive

echo "Deployment finished successfully."
