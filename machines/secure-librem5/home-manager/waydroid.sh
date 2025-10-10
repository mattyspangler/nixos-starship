#!/bin/bash

# Exit on error and undefined variables, but allow pipes to fail
set -eu

# A script to automate the installation and configuration of Waydroid on postmarketOS,
# with optional arguments for customizing the setup.
# 
# This script is specifically designed for postmarketOS running systemd.
# It handles Waydroid installation, initialization, and common fixes.

# --- Default Settings ---
APPLY_PULSE_FIX=false
APPLY_NETWORK_FIX=false
IMAGE_TYPE="" # Empty means interactive prompt
SKIP_PREREQ=false

# --- Colors for output ---
C_RESET='\033[0m'
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[0;33m'
C_CYAN='\033[0;36m'

# --- Helper Functions ---
info() { echo -e "${C_CYAN}[INFO]${C_RESET} $1"; }
success() { echo -e "${C_GREEN}[SUCCESS]${C_RESET} $1"; }
warn() { echo -e "${C_YELLOW}[WARNING]${C_RESET} $1"; }
fail() { echo -e "${C_RED}[ERROR]${C_RESET} $1"; exit 1; }

show_help() {
    echo "Usage: sudo ./waydroid.sh [OPTIONS]"
    echo
    echo "Options:"
    echo "  --gapps              Initialize Waydroid with the Google Apps (GAPPS) image instead of VANILLA."
    echo "  --fix-all            Apply all recommended fixes (PulseAudio and networking)."
    echo "  --fix-pulse          Apply PulseAudio suspend fix."
    echo "  --fix-network        Apply iptables networking fixes."
    echo "  --skip-prereq        Skip kernel prerequisite checks."
    echo "  -h, --help           Show this help message and exit."
    echo
}

# --- Argument Parsing ---
while [[ $# -gt 0 ]]; do
    case "$1" in
        --gapps)
            IMAGE_TYPE="GAPPS"
            shift
            ;;
        --fix-all)
            APPLY_PULSE_FIX=true
            APPLY_NETWORK_FIX=true
            shift
            ;;
        --fix-pulse)
            APPLY_PULSE_FIX=true
            shift
            ;;
        --fix-network)
            APPLY_NETWORK_FIX=true
            shift
            ;;
        --skip-prereq)
            SKIP_PREREQ=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            fail "Unknown option: $1. Use --help for available options."
            ;;
    esac
done

# --- Main Functions ---

check_root() {
    if [ "$EUID" -ne 0 ]; then
        fail "This script must be run with root privileges. Please use 'sudo ./waydroid.sh'"
    fi
}

check_prerequisites() {
    if [ "$SKIP_PREREQ" = true ]; then
        warn "Skipping kernel prerequisite checks as requested."
        return
    fi

    info "Checking kernel prerequisites..."
    if [ ! -f /proc/config.gz ]; then
        warn "Could not find /proc/config.gz. Unable to verify kernel configuration automatically."
        read -p "Do you want to continue anyway? (y/N): " choice
        [[ "$choice" =~ ^[Yy]$ ]] || fail "Aborting. Please manually verify kernel support."
        return
    fi

    if ! zcat /proc/config.gz | grep -q "CONFIG_BINDER_FS=y"; then fail "Kernel is missing BINDER_FS support (CONFIG_BINDER_FS=y)."; fi
    if ! zcat /proc/config.gz | grep -q "CONFIG_ASHMEM=y"; then fail "Kernel is missing ASHMEM support (CONFIG_ASHMEM=y)."; fi
    if zcat /proc/config.gz | grep -q "CONFIG_RT_GROUP_SCHED=y"; then fail "CONFIG_RT_GROUP_SCHED=y is enabled and must be disabled."; fi

    success "Kernel prerequisites are met."
}

install_packages() {
    info "Installing Waydroid and dependencies on postmarketOS..."
    
    # postmarketOS uses Alpine's apk package manager
    if ! apk update; then
        fail "Failed to update package lists."
    fi
    
    if ! apk add waydroid waydroid-systemd iptables; then
        fail "Failed to install required packages."
    fi
    
    success "Waydroid and dependencies installed."
}

initialize_waydroid() {
    # Check if waydroid command exists
    if ! command -v waydroid >/dev/null 2>&1; then
        fail "The waydroid command was not found. Make sure it's properly installed."
    fi

    if [ -z "$IMAGE_TYPE" ]; then
        info "Waydroid needs an Android image to be initialized."
        read -p "Choose image type [VANILLA/GAPPS] (default: VANILLA): " choice
        if [[ "${choice^^}" == "GAPPS" ]]; then
            IMAGE_TYPE="GAPPS"
        else
            IMAGE_TYPE="VANILLA"
        fi
    fi
    
    info "Initializing Waydroid with $IMAGE_TYPE image. This may take a while..."
    if ! waydroid init -s "$IMAGE_TYPE"; then
        fail "Waydroid initialization failed. Please check the output above."
    fi
    success "Waydroid initialized successfully."
}

configure_services() {
    info "Enabling systemd services for Waydroid..."
    if ! systemctl enable waydroid-container.service; then
        warn "Failed to enable waydroid-container.service. You may need to start it manually after reboot."
        warn "Command to start manually: 'systemctl start waydroid-container.service'"
    fi
    success "Waydroid service enabled to start on boot."
}

load_required_modules() {
    info "Loading required kernel modules..."
    if ! lsmod | grep -q "^loop"; then
        if ! modprobe loop; then
            fail "Failed to load 'loop' module. Waydroid cannot function without it."
        fi
    fi
    success "Kernel modules loaded."
}

apply_fixes() {
    # Fix 1: PulseAudio suspend issue - prevents audio cutouts in Waydroid
    if [ "$APPLY_PULSE_FIX" = true ]; then
        PULSE_CONF="/etc/pulse/default.pa"
        if [ -f "$PULSE_CONF" ]; then
            info "Applying PulseAudio fix: Disabling suspend-on-idle..."
            # Comment out the line if it exists and is not already commented
            sed -i -E 's/^(load-module module-suspend-on-idle)/# \1/' "$PULSE_CONF"
            success "PulseAudio fix applied."
        else
            warn "PulseAudio config not found at $PULSE_CONF"
        fi
    fi

    # Fix 3: Network connectivity - allows Waydroid to access the internet
    if [ "$APPLY_NETWORK_FIX" = true ]; then
        info "Applying firewall rules for Waydroid networking..."
        if ! iptables -I INPUT -i waydroid0 -j ACCEPT || ! iptables -I FORWARD -i waydroid0 -j ACCEPT; then
            warn "Failed to apply some iptables rules. Waydroid may have limited connectivity."
        else
            # Make the rules persistent using Alpine's iptables-save mechanism
            if command -v iptables-save >/dev/null 2>&1; then
                info "Making iptables rules persistent..."
                # Create rules directory and save rules
                mkdir -p /etc/iptables
                if ! iptables-save > /etc/iptables/rules-save; then
                    warn "Failed to save iptables rules. They will not persist after reboot."
                    warn "You can manually add these rules to your firewall configuration:"
                    warn "iptables -I INPUT -i waydroid0 -j ACCEPT"
                    warn "iptables -I FORWARD -i waydroid0 -j ACCEPT"
                else
                    info "Saved iptables rules to persist across reboots."
                fi
            else
                warn "Could not find iptables-save. Rules will not persist after reboot."
                info "To make rules persistent, add these lines to your startup scripts:"
                info "iptables -I INPUT -i waydroid0 -j ACCEPT"
                info "iptables -I FORWARD -i waydroid0 -j ACCEPT"
            fi
            success "Networking fixes applied successfully."
        fi
    fi
}

# --- Script Execution ---

clear
echo "=========================================="
echo "  Waydroid Setup Script for postmarketOS  "
echo "=========================================="
echo

check_root
check_prerequisites
install_packages
load_required_modules
initialize_waydroid
configure_services

# Apply fixes if any were requested
if [ "$APPLY_PULSE_FIX" = true ] || [ "$APPLY_NETWORK_FIX" = true ]; then
    apply_fixes
else
    info "No fixes were requested. Use --fix-pulse or --fix-network to apply specific fixes."
fi

echo
success "All steps completed!"
info "It is highly recommended to REBOOT your device for all changes to take effect."
info "After rebooting, check status with 'waydroid status' and launch from your app menu."
echo