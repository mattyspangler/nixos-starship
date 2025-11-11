#!/bin/sh
#
# Cardiotop Setup Script
#
# This script installs the cardiotop application and its dependencies
# into an isolated environment using pipx.

set -e

# Get the directory of this script and cd into it
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
cd "$SCRIPT_DIR"

# --- System Dependency Check ---
echo "--- Checking and Installing Dependencies ---"

# Check for postmarketOS/Alpine
if command -v apk >/dev/null 2>&1; then
    echo "Detected postmarketOS/Alpine. Installing dependencies with apk..."
    REQUIRED_PKGS="py3-bleak py3-textual py3-dasbus py3-geopy py3-nmea2 geoclue"
    if ! sudo apk add $REQUIRED_PKGS; then
        echo "ERROR: Failed to install system dependencies with apk." >&2
        exit 1
    fi

    echo "\n--- Enabling and Starting System Services ---"
    echo "Enabling and starting GeoClue service..."
    sudo systemctl enable geoclue
    sudo systemctl start geoclue
else
    echo "Detected a non-Alpine system. Installing dependencies with pipx..."
    if ! command -v pipx >/dev/null 2>&1; then
        echo "ERROR: pipx is not installed. Please install it first." >&2
        exit 1
    fi
    
    # Read dependencies from requirements.txt
    while IFS= read -r dep; do
        if ! pipx inject cardiotop "$dep"; then
            echo "Warning: Could not inject '$dep'. It might already be satisfied."
        fi
    done < requirements.txt
fi

echo "\n--- Setup Complete ---"
echo "Dependencies have been installed."
echo "You can now run the cardiotop scripts directly from this directory."
echo ""
echo "IMPORTANT: To use the GPS feature, you must first authorize the application."
echo "Please run the following command in a separate terminal and keep it open:"
echo "  /usr/libexec/geoclue-2.0/demos/agent"
echo ""
echo "Then, you can test the GPS with:"
echo "  ./cardiotop-device --profile gps_default"
