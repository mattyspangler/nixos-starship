# AGENTS.md - Guide for Working in This NixOS Configuration Repository

This document provides essential information for agents working with this NixOS configuration repository.

## Repository Overview

This is a comprehensive NixOS configuration managing multiple devices with different architectures and use cases:
- **Desktop systems**: gaming-desktop, vm-workstation, secure-laptop
- **Mobile devices**: pinephone-pro, secure-librem5, android-tablet
- **Server systems**: k3s-server-master, k3s-server-agent, k3s-server-agent-2, media-server
- **Specialized devices**: hacking-uconsole, hacking-devterm

## Essential Commands

### System Management
```bash
# Update flake inputs
nix flake update

# Build and switch to new configuration (for specific machine)
sudo nixos-rebuild switch --flake .#<machine-name>

# Test configuration without switching
sudo nixos-rebuild test --flake .#<machine-name>

# Rollback to previous generation
sudo nixos-rebuild switch --flake .# --rollback

# Clean up old generations
sudo nix-collect-garbage --delete-old

# Optimize nix store
nix store optimise
```

### Home Manager (Standalone)
```bash
# Switch standalone home-manager configuration
home-manager switch --extra-experimental-features 'nix-command flakes' --flake .#user@standalone-dev

# For Librem 5 standalone
home-manager switch --extra-experimental-features 'nix-command flakes' --flake .#nebula@libremfive
```

### Deployment Scripts
Use the provided deployment scripts for each machine:
- `deploy_gaming-desktop.sh`
- `deploy_secure-laptop.sh`
- `deploy_android_tablet.sh`
- `deploy_librem5_standalone.sh`
- `deploy_standalone-dev.sh`
- `deploy_media-server.sh`

### Quality Checks
```bash
# Run static analysis (excludes some WIP directories)
./quality_checks.sh
```

### Secrets Management
```bash
# Edit encrypted secrets
nix-shell -p sops --run "sops secrets/secrets.yaml"
```

## Code Structure and Organization

### Directory Hierarchy
- `common/core/` - Universal system configs applied to ALL devices
- `common/desktop/` - Shared desktop environment configs
- `common/home-manager/core/` - Universal user-level configs
- `common/home-manager/desktop/` - Desktop-specific user configs
- `common/home-manager/standalone/` - Non-NixOS environment configs
- `common/home-manager/nix-on-droid/` - Android-specific configs
- `machines/<device>/` - Device-specific configurations
- `modules/` - Reusable NixOS modules
- `overlays/` - Custom package overlays
- `pkgs/` - Custom packages
- `secrets/` - Encrypted secrets (managed with sops-nix)

### Configuration Patterns
1. **Modular Design**: Common configurations are separated into reusable modules
2. **Layered Approach**: Core → Desktop/Server → Machine-specific
3. **Home Manager Integration**: User configs managed alongside system configs
4. **Security-First**: Comprehensive hardening with nix-mineral and other security measures

## Key Technologies and Patterns

### Core Technologies
- **Flakes**: Modern Nix packaging with reproducible builds
- **Home Manager**: User environment management
- **Sops-nix**: Encrypted secrets management with age/FIDO2-HMAC
- **Nixpak**: Application sandboxing
- **Nix-mineral**: Security hardening framework

### Security Features
- AppArmor profiles
- AIDE integrity checking
- ClamAV antivirus
- Flatpak sandboxing
- Kernel hardening
- Noexec protections
- FIDO2-HMAC for secrets

### Desktop Environment
- **SwayWM**: Tiling window manager with Wayland
- **Waybar**: Status bar
- **Wofi**: Application launcher with AI integration
- **Doom Emacs**: Primary editor with AI packages
- **Alacritty**: Terminal emulator

## Important Gotchas

### Path Issues
- Secrets paths are hardcoded and need to be made relative with `mkDefault`
- User "nebula" is hardcoded in some places - needs abstraction for other users

### Exclusions
- `hacking-uconsole/` directory is excluded from quality checks (WIP from external repo)
- Doom Emacs config is excluded from checks to maintain sync with upstream

### Architecture Considerations
- Different architectures: `x86_64-linux` and `aarch64-linux`
- Some packages need architecture-specific handling
- Mobile devices have special constraints

### Home Manager State Versions
- Critical: Always check home-manager release notes before updating state versions
- Different machines may have different state versions (e.g., "24.05", "24.11")

## Testing and Validation

### Before Applying Changes
1. Run `nixos-rebuild test` first to verify configuration
2. Check for syntax errors with quality checks
3. Verify secrets are properly configured

### Security Verification
- Ensure AIDE scans are scheduled
- Verify AppArmor profiles are loaded
- Check firewall rules
- Test encrypted secrets access

## Common Workflows

### Adding New Machine
1. Create directory under `machines/<machine-name>/`
2. Add hardware configuration
3. Add machine configuration
4. Add to `flake.nix` in `nixosConfigurations`
5. Create deployment script if needed

### Updating Packages
1. Run `nix flake update`
2. Review changelogs
3. Test with `nixos-rebuild test`
4. Apply with deployment script or `nixos-rebuild switch`

### Managing Secrets
1. Edit with `sops secrets/secrets.yaml`
2. Age keys are stored in `/var/lib/sops/keys.txt` (system) and `/home/nebula/.config/sops/age/keys.txt` (user)
3. FIDO2-HMAC is the primary encryption method

## Documentation References
- `docs/directory-structure.org` - Detailed structure explanation
- `docs/update-steps.org` - Step-by-step update process
- `docs/theming.org` - Theme configuration
- `docs/secret-management.org` - Secrets management guide

## Configuration Philosophy
- **Security First**: Comprehensive hardening on all systems
- **Modular**: Reusable components across devices
- **Reproducible**: Flake-based for consistency
- **Flexible**: Support for diverse hardware and use cases
- **Maintainable**: Clear separation of concerns and documentation