#!/usr/bin/env bash

# Installation script for LiteLLM Expander

set -e

# Get the directory where the script is located
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
CONFIG_DIR="$HOME/.config/espanso"

echo "Installing LiteLLM Expander for Espanso..."

# Check for Python and pip
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is required but not found. Please install Python 3."
    exit 1
fi

# Check for LiteLLM
if ! python3 -c "import litellm" &> /dev/null; then
    echo "LiteLLM not found. Installing..."
    pip3 install --user litellm
fi

# Create the configuration directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Copy the default configuration if it doesn't exist
if [ ! -f "$CONFIG_DIR/litellm_config.yaml" ]; then
    echo "Creating default configuration..."
    cp "$SCRIPT_DIR/default_config.yaml" "$CONFIG_DIR/litellm_config.yaml"
    echo "Default configuration created at $CONFIG_DIR/litellm_config.yaml"
    echo "Please edit this file to add your API keys and customize settings."
fi

# Make the script executable
chmod +x "$SCRIPT_DIR/litellm_expander.py"

echo "Installation complete!"
echo "You can now use the LiteLLM Expander with espanso."
echo "Try typing ';llm hello world;' to test it out."
echo "See the README.md for more usage instructions."