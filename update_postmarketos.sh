#!/usr/bin/env bash
set -e

echo "Updating PostmarketOS..."
sudo apk upgrade --available

echo "Running Nix deployment script..."
./deploy_librem5_standalone.sh "$@"

echo "Update and deployment finished successfully."