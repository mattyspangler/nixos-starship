#!/bin/bash

# A script to automate the installation and configuration of Waydroid on postmarketOS,
# with optional arguments for customizing the setup.

# --- Default Settings ---
APPLY_FIXES=true
IMAGE_TYPE="" # Empty means interactive prompt

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
    echo "Usage: sudo ./setup-waydroid.sh [OPTIONS]"
    echo
    echo "Options:"
    echo "  --gapps       Initialize Waydroid with the Google Apps (GAPPS) image instead of VANILLA."
    echo "  --no-fixes    Skip the post-install fixes (PulseAudio, networking, loop module)."
    echo "                Recommended only for advanced users or non-Phosh environments."
    echo "  -h, --help    Show this help message and exit."
    echo
}

# --- Argument Parsing ---
while [[ $# -gt 0 ]]; do
    case "$1" in
        --gapps)
            IMAGE_TYPE="GAPPS"
            shift
            ;;
        --no-fixes)
            APPLY_FIXES=false
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
        fail "This script must be run with root privileges. Please use 'sudo ./setup-waydroid.sh'"
    fi
}

check_prerequisites() {
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
    info "Updating package lists and installing Waydroid + dependencies..."
    apk update
    apk add waydroid-systemd iptables
    success "Waydroid and dependencies installed."
}

initialize_waydroid() {
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
    info "Configuring OpenRC services for cgroups and Waydroid container..."
    rc-update add cgroups default
    rc-service cgroups start
    rc-update add waydroid-container default
    success "Services configured to start on boot."
}

apply_fixes() {
    info "Applying common post-install fixes from the wiki..."

    # 1. Fix PulseAudio suspend issue on Phosh/GNOME
    PULSE_CONF="/etc/pulse/default.pa"
    if [ -f "$PULSE_CONF" ] && grep -q "^load-module module-suspend-on-idle" "$PULSE_CONF"; then
        info "--> Disabling PulseAudio suspend-on-idle..."
        sed -i 's/^load-module module-suspend-on-idle/#load-module module-suspend-on-idle/' "$PULSE_CONF"
    fi

    # 2. Ensure 'loop' kernel module is loaded for mounting images
    if ! lsmod | grep -q "^loop"; then
        info "--> Loading 'loop' kernel module..."
        modprobe loop
    fi
    
    # 3. Apply basic firewall rules for internet access
    info "--> Applying firewall rules for Waydroid networking..."
    iptables -I INPUT -i waydroid0 -j ACCEPT
    iptables -I FORWARD -i waydroid0 -j ACCEPT

    success "Common fixes have been applied."
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
initialize_waydroid
configure_services

if [ "$APPLY_FIXES" = true ]; then
    apply_fixes
else
    warn "Skipping post-install fixes as requested by --no-fixes flag."
fi

echo
success "All steps completed!"
info "It is highly recommended to REBOOT your device for all changes to take effect."
info "After rebooting, check status with 'waydroid status' and launch from your app menu."
echo