## Introduction
This is a NixOS configuration repository for various devices, including desktops, laptops, and mobile devices. It uses the Nix package manager and the NixOS operating system.

## Essential Commands
* `nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs` - Add nixpkgs channel
* `nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager` - Add home-manager channel
* `nix-channel --update` - Update nix channels
* `nix-shell '<home-manager>' -A install` - Install home-manager
* `home-manager build --extra-experimental-features 'nix-command flakes' --flake .#nebula@libremfive` - Build home-manager configuration
* `home-manager switch --extra-experimental-features 'nix-command flakes' --flake .#nebula@libremfive` - Switch to new home-manager generation

## Deploy Scripts

### System Configuration (NixOS)
* `sudo ./deploy_gaming-desktop.sh` - Rebuild gaming desktop with full NixOS configuration
* `sudo ./deploy_secure-laptop.sh` - Rebuild secure laptop with full NixOS configuration
* `sudo ./deploy_media-server.sh` - Rebuild media server with full NixOS configuration
* `sudo ./deploy_android_tablet.sh` - Rebuild Android tablet with full NixOS configuration

### Home Manager Configuration
* `./deploy_librem5_standalone.sh` - Deploy home-manager for Librem 5 (standalone)
* `./deploy_librem5_standalone.sh --clean` - Deploy with cleanup of old generations
* `./deploy_standalone-dev.sh` - Deploy home-manager for standalone development environment

## ZSH Aliases

### NixOS Rebuild Commands
* `nrs-gaming-desktop` - `sudo nixos-rebuild switch --flake ~/nixos-starship/#gaming-desktop --option binary-caches-parallel-connections 5`

### Home Manager Deploy Commands
* `hms-librem` - `~/nixos-starship/deploy_librem5_standalone.sh`

### Emacs/Doom Commands
* `der` - `~/.config/emacs/bin/doom build && ~/.config/emacs/bin/doom sync`
* `des` - `~/.config/emacs/bin/doom sync`

### General Aliases
* `ll` - `ls -la`
* `pip` - `pip3`

## Manual Rebuild Commands

### NixOS System Rebuild
* `sudo nixos-rebuild switch --flake ~/nixos-starship/#hostname` - Rebuild and switch to new configuration
* `sudo nixos-rebuild build --flake ~/nixos-starship/#hostname` - Build without switching
* `sudo nixos-rebuild test --flake ~/nixos-starship/#hostname` - Test configuration temporarily

### Home Manager Rebuild
* `home-manager switch --extra-experimental-features 'nix-command flakes' --flake .#user@hostname` - Switch to new home-manager generation
* `home-manager build --extra-experimental-features 'nix-command flakes' --flake .#user@hostname` - Build without switching
* `home-manager generations` - List home-manager generations
* `home-manager remove-generations` - Remove old generations

## Code Organization and Structure
The code is organized into several directories:
* `common` - Common configuration files
* `machines` - Device-specific configuration files
* `modules` - NixOS modules
* `overlays` - NixOS overlays
* `pkgs` - Custom packages

## Naming Conventions and Style Patterns
The code follows the standard NixOS naming conventions and style patterns.

## Testing Approach and Patterns
The testing approach is based on the NixOS testing framework.

## Important Gotchas or Non-Obvious Patterns
* The `nixos-rebuild` command must be run with the `--flake` option to use the flake configuration.
* The `home-manager` command must be run with the `--extra-experimental-features 'nix-command flakes'` option to use the flake configuration.

## Project-Specific Context
The project uses the NixOS operating system and the Nix package manager. It is designed to be used with various devices, including desktops, laptops, and mobile devices.

## Available Deploy Scripts
The repository contains deploy scripts for different machines and configurations:

### NixOS System Deploy Scripts (require sudo)
* `deploy_gaming-desktop.sh` - Full system rebuild for gaming desktop
* `deploy_secure-laptop.sh` - Full system rebuild for secure laptop
* `deploy_media-server.sh` - Full system rebuild for media server
* `deploy_android_tablet.sh` - Full system rebuild for Android tablet

### Home Manager Deploy Scripts
* `deploy_librem5_standalone.sh` - Home manager deployment for Librem 5
* `deploy_standalone-dev.sh` - Home manager deployment for standalone development

## Usage Examples
```bash
# Deploy gaming desktop system
sudo ./deploy_gaming-desktop.sh

# Deploy home manager with cleanup
./deploy_librem5_standalone.sh --clean

# Use zsh aliases for quick rebuilds
nrs-gaming-desktop  # Rebuild gaming desktop
hms-librem         # Deploy home manager to Librem 5
```