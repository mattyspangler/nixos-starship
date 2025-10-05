#!/usr/bin/env bash
set -e

# This script deploys the home-manager configuration.
# It includes steps for the initial setup of channels, making it suitable for first-time installs.

echo "Checking for nix channels..."
# If channels are not configured, run the first-time setup.
if ! nix-channel --list | grep -q "^nixpkgs " || ! nix-channel --list | grep -q "^home-manager "; then
    echo "One or more channels are missing. Running first-time setup..."
    # Adding 'nixpkgs' as the channel name for clarity and robustness.
    nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update && nix-shell '<home-manager>' -A install
else
    echo "Channels are already configured. Skipping setup."
fi

# The following commands require 'home-manager', which might not be in the PATH.
# We use nix-shell to provide the command in a self-contained way.
nix-shell '<home-manager>' -A install --run "$(cat <<'EOF'
set -e
echo "Cleaning old home-manager generations..."
# The awk script skips the first 3 lines and prints the last field (the generation number) of the rest.
home-manager generations | awk 'NR > 3 {print $NF}' | xargs -r -- home-manager remove-generations

echo "Deploying home-manager configuration via flake..."
home-manager switch --extra-experimental-features 'nix-command flakes' --flake .#nebula@libremfive
EOF
)"

echo "Deployment finished successfully."
