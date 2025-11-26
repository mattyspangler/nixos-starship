# NixOS Configuration - Best Practices Audit & Improvements

This document identifies areas for improvement in the NixOS configuration repository to ensure it follows best practices, maintains good modularity, and minimizes technical debt before uploading to GitHub.

## 🚨 Critical Issues (Must Fix)

### flake.nix
- **[C1]**: Syntax error - `extraSpecialArgs = inputs { inherit inputs doomemacs; };` should be `extraSpecialArgs = { inherit inputs doomemacs; };`
- **[C2]**: References to non-existent modules `./modules/nixos` and `./modules/home-manager`
- **[C3]**: Broken imports `./home/base` and `./home/handheld` (files don't exist)
- **[C4]**: Large blocks of commented home-manager code should be removed

## 📁 Structural & Organizational Issues

### Modularity Concerns
- **Inconsistent home-manager patterns**: Some machines include home-manager, others don't without clear documentation
- **Missing module structure**: flake.nix references modules that don't exist, indicating incomplete refactoring
- **Complex device-specific overlays**: hacking-uconsole has 10+ overlay files that may be overengineered

### File Organization
- **Mixed configuration approaches**: Some machines use structured approach, others have everything in configuration.nix
- **Inconsistent naming**: Some directories use hyphens, others use underscores
- **Missing documentation**: No clear guide for adding new machines or configurations

## 🔍 Detailed Code Analysis (By Category)

## 🔄 Audit Process

### How to Continue This Audit
This document uses an iterative approach to systematically review all Nix files in the repository:

1. **Pick any TODO item** from the "Files Pending Review" sections below
2. **Read and analyze** the corresponding .nix files
3. **Update improvements.md** with findings, using the labeled issue system
4. **Mark the TODO as DONE** by changing "TODO" to "✅ DONE - [summary]"
5. **Add new issue labels** if you discover additional problems

### Example Progress Update:
```
- **common/core/zsh/**: TODO - Review shell configuration patterns
```
Becomes:
```
- **common/core/zsh/**: ✅ DONE - Reviewed - found [Q7] unused bindings, [M9] over-modularization
```

This systematic approach ensures all files are reviewed before the GitHub upload and creates a complete audit trail of improvements needed.

### ✅ Files Already Reviewed
- **flake.nix**: Complete analysis done - identified critical syntax errors, missing modules, and structural issues
- **common/core/default.nix**: Reviewed - has hardcoded paths, unused bindings, TODOs for relative paths
- **common/desktop/default.nix**: Reviewed - configuration duplication, hardcoded user, unused bindings
- **common/home-manager/core/default.nix**: Reviewed - hardcoded paths, unused bindings, security concerns
- **overlays/default.nix**: Reviewed - simple and clean, no issues
- **modules/security/apparmor.nix**: Reviewed - well-structured module, minor unused binding
- **machines/gaming-desktop/default.nix**: Reviewed - hardcoded paths, security concerns, unused bindings

### 📋 Files Pending Review
The following files have NOT been reviewed yet and need analysis:

#### Core System Files
- **common/core/zsh/**: ✅ DONE - Reviewed - found [Q7] unused config binding, [S9] hardcoded paths in aliases, [M10] machine-specific aliases in common config
- **common/core/nitrokey/**: ✅ DONE - Reviewed - clean configuration, no issues
- **common/core/flatpak/**: ✅ DONE - Reviewed - found [Q8, Q9] unused config/lib bindings
- **common/core/bash/**: ✅ DONE - Reviewed - found [Q10, Q11] unused config/pkgs bindings

#### Desktop Components (17 subdirectories)
- **common/desktop/sway/default.nix**: ✅ DONE - Reviewed - clean systemd service configuration, no issues
- **common/desktop/steam/default.nix**: ✅ DONE - Reviewed - found [Q21, Q22] unused config/pkgs bindings
- **common/desktop/virtualisation/default.nix**: ✅ DONE - Reviewed - clean import structure, no issues
- **common/desktop/hardening/default.nix**: ✅ DONE - Reviewed - comprehensive security hardening, well-documented
- **common/desktop/** (13 remaining subdirs): TODO - Need to review remaining desktop components

#### ARM Desktop
- **common/desktop-arm/default.nix**: ✅ DONE - Reviewed - found [D4] broken import paths, [M11] hardware-specific config in common
- **common/desktop-arm/deskpi-tools.nix**: ✅ DONE - Reviewed - clean systemd service definitions, no issues
- **common/desktop-arm/trim.nix**: ✅ DONE - Reviewed - found [Q12] unused types binding

#### Server Components
- **common/server/default.nix**: ✅ DONE - Reviewed - found [Q13, Q14] unused bindings, [Q15] unused with, [D5] commented hardening, [D6] config duplication with desktop, [S10] hardcoded user "library"
- **common/server/hardening/**: TODO - Review security hardening modules (8 subdirectories)
- **common/server/virtualisation/**: TODO - Check virtualization setup
- **common/server/qdrant/**: TODO - Review database configuration

#### Nix-on-Droid
- **common/nix-on-droid/default.nix**: ✅ DONE - Reviewed - found [Q16-Q19] unused bindings, minimal config
- **common/nix-on-droid/syncthing/**: ✅ DONE - Reviewed - found [Q20] unused pkgs binding, [S11] hardcoded Android paths

#### Home-Manager Submodules
- **common/home-manager/core/zsh/**: TODO - Review user shell setup
- **common/home-manager/core/ml/**: TODO - Check machine learning tools
- **common/home-manager/core/dev/**: TODO - Review development environment
- **common/home-manager/core/bash/**: TODO - Review user bash configuration
- **common/home-manager/core/emacs/**: TODO - Review Emacs setup
- **common/home-manager/core/aliases.nix**: TODO - Check shell aliases
- **common/home-manager/core/my-alarms/**: TODO - Review alarm configuration
- **common/home-manager/core/nixpak/**: TODO - Review sandboxing setup
- **common/home-manager/desktop/**: All 6 subdirectories need review
- **common/home-manager/standalone/**: TODO - Review standalone configuration
- **common/home-manager/nix-on-droid/**: TODO - Review Android user config

#### Machine-Specific Configurations
- **machines/gaming-desktop/hardware-configuration.nix**: TODO - Review hardware config
- **machines/gaming-desktop/home-manager/**: TODO - Review user config
- **machines/gaming-desktop/sway/**: TODO - Review window manager setup
- **machines/secure-laptop/default.nix**: ✅ DONE - Reviewed - found [Q23, Q24] unused bindings, [Q25] unused with, [D8] hardcoded LUKS UUIDs, [D9] mostly commented config
- **machines/vm-workstation/default.nix**: ✅ DONE - Reviewed - found [Q26, Q27] unused bindings, [Q28] unused with, [S15] hardcoded IP addresses
- **machines/vm-server/**: TODO - Review server VM setup (2 files)
- **machines/media-server/default.nix**: ✅ DONE - Reviewed - found [Q29, Q30] unused bindings, [D10] empty configuration file
- **machines/pinephone-pro/**: TODO - Review PinePhone configuration (4 files)
- **machines/secure-librem5/**: TODO - Review Librem 5 setup (5 files)
- **machines/android-tablet/**: TODO - Check Android tablet config (1 file)
- **machines/hacking-uconsole/**: TODO - Review uConsole kernel/device mods (19+ files)
- **machines/hacking-devterm/**: TODO - Check DevTerm configuration (1 file)
- **machines/k3s-server-master/**: TODO - Review K3s master setup (1 file)
- **machines/k3s-server-agent/**: TODO - Review K3s agent config (1 file)
- **machines/k3s-server-agent-2/**: TODO - Review second agent setup (1 file)
- **machines/standalone/dev-vm/**: TODO - Review development VM (1 file)
- **machines/standalone/sync-vm/**: TODO - Check synchronization VM (1 file)

#### Packages & Overlays
- **overlays/weechat.nix**: ✅ DONE - Reviewed - found [U51] unused self parameter, functional overlay
- **pkgs/default.nix**: ✅ DONE - Reviewed - template structure, no issues

### Core Configuration Issues

#### Common Core (common/core/default.nix) ⚠️
- **[S1]**: Hardcoded paths - Lines 19, 94, 96 use `/home/nebula/nixos-starship/` - should use relative paths or configurable paths
- **[Q1]**: Unused bindings - config, lib, inputs parameters not used (lines 2, 4, 5)
- **[D1]**: TODO comments - Lines 18, 22 indicate incomplete configuration for multi-user setups
- **[S2]**: Security concern - SOPS key file path hardcoded for single user
- **[P1]**: Package bloat - Some packages like clamav, aide may not be needed on all systems

#### Common Core ZSH (common/core/zsh/default.nix) ⚠️
- **[Q7]**: Unused binding - config parameter not used (line 1)
- **[S9]**: Hardcoded paths - Aliases use hardcoded `~/nixos-starship/` paths (lines 19, 20)
- **[M10]**: Machine-specific aliases in common config - Should be machine-specific, not in common core

#### Common Desktop (common/desktop/default.nix) ⚠️
- **[D2]**: Configuration duplication - Time zone and locale settings duplicate common/core/default.nix (lines 37, 40-53)
- **[S3]**: Hardcoded user - "nebula" user hardcoded (lines 75, 78)
- **[Q2]**: Unused bindings - lib, config parameters not used (lines 5, 8)
- **[M1]**: Monolithic structure - 25+ imports suggest this file may be doing too much
- **[P2]**: Package bloat - Large system package list with some questionable entries (cmatrix for production?)
- **[C5]**: Inconsistent commenting - Mix of commented and uncommented code blocks

#### Home-Manager Core (common/home-manager/core/default.nix) ⚠️
- **[S4]**: Hardcoded paths - Lines 94, 96 use absolute paths for nebula user
- **[S5]**: Security concern - SOPS configuration with hardcoded user paths
- **[P3]**: Large package list - 80+ packages, many may not be needed on all systems
- **[Q3]**: Unused bindings - config parameter not used (line 2)
- **[M2]**: Missing abstraction - No way to customize package sets per machine type

#### Gaming Desktop (machines/gaming-desktop/default.nix) ⚠️
- **[S6]**: Hardcoded paths - Lines 31, 32, 35, 36, 45 use absolute paths to external drive
- **[S7]**: Security concern - Service runs as user "nebula" instead of dedicated service user
- **[Q4]**: Unused bindings - config parameter not used (line 1)
- **[D3]**: External dependencies - Configuration depends on external drive being mounted

#### Common Core Flatpak (common/core/flatpak/default.nix) ⚠️
- **[Q8, Q9]**: Unused bindings - config, lib parameters not used (lines 2, 3)
- **Good practice**: Simple, focused configuration - this is well structured

#### Common Core Bash (common/core/bash/default.nix) ⚠️
- **[Q10, Q11]**: Unused bindings - config, pkgs parameters not used (lines 1, 3)
- **Note**: Very minimal configuration, could potentially be merged with zsh config

#### Common Desktop ARM (common/desktop-arm/default.nix) ⚠️
- **[D4]**: Broken import paths - Lines 20-21 reference `../raspberry-pi/overlays` and `../raspberry-pi/apply-overlays` (files don't exist)
- **[M11]**: Hardware-specific configuration in common module - Should be machine-specific

#### Common Desktop ARM Trim (common/desktop-arm/trim.nix) ⚠️
- **[Q12]**: Unused binding - types parameter not used (line 6)
- **Good practice**: Simple, focused udev rule configuration

#### Common Server (common/server/default.nix) ⚠️
- **[Q13, Q14]**: Unused bindings - config, pkgs parameters not used (lines 5, 24)
- **[Q15]**: Unused with statement - `with pkgs;` on line 24 but packages list is empty
- **[D5]**: Commented hardening import - Line 9 indicates incomplete security configuration
- **[D6]**: Configuration duplication - Large overlap with common/desktop/default.nix (fonts, packages, services)
- **[S10]**: Hardcoded user - "library" user hardcoded (line 20)

#### Common Nix-on-Droid (common/nix-on-droid/default.nix) ⚠️
- **[Q16-Q19]**: Unused bindings - config, pkgs, lib, inputs parameters not used (lines 2-5)
- **Note**: Minimal configuration with commented package section

#### Common Nix-on-Droid Syncthing (common/nix-on-droid/syncthing/default.nix) ⚠️
- **[Q20]**: Unused binding - pkgs parameter not used (line 2)
- **[S11]**: Hardcoded Android paths - Line 10 uses hardcoded Android data path

#### Common Desktop Steam (common/desktop/steam/default.nix) ⚠️
- **[Q21, Q22]**: Unused bindings - config, pkgs parameters not used (lines 2, 3)
- **Good practice**: Clean udev rules integration for game controllers

#### Common Desktop Hardening (common/desktop/hardening/default.nix) ✅
- **Excellent security configuration**: Comprehensive hardening with good documentation
- **Well-structured**: Proper use of mkDefault for overrideable settings
- **Good commenting**: Extensive references and explanations of security tradeoffs

#### Common Desktop Steam (common/desktop/steam/default.nix) ⚠️
- **[Q21, Q22]**: Unused bindings - config, pkgs parameters not used (lines 2, 3)
- **Good practice**: Clean udev rules integration for game controllers

#### Common Desktop Hardening (common/desktop/hardening/default.nix) ✅
- **Excellent security configuration**: Comprehensive hardening with good documentation
- **Well-structured**: Proper use of mkDefault for overrideable settings
- **Good commenting**: Extensive references and explanations of security tradeoffs

#### Overlays Weechat (overlays/weechat.nix) ⚠️
- **[U51]**: Unused binding - self parameter not used (line 1)
- **Functional**: Proper overlay structure with Python plugin configuration

#### Overlays & Modules ✅
- **overlays/default.nix**: Clean, simple structure - no issues
- **modules/security/apparmor.nix**: Well-structured module, only minor unused binding [Q5]
- **common/core/nitrokey/**: ✅ DONE - Reviewed - clean configuration, no issues
- **pkgs/default.nix**: ✅ DONE - Reviewed - template structure, no issues

#### Secure Laptop (machines/secure-laptop/default.nix) ⚠️
- **[Q23, Q24]**: Unused bindings - lib, config parameters not used (lines 5)
- **[Q25]**: Unused with statement - `with pkgs;` on line 112 but packages list is empty
- **[D8]**: Security concern - Hardcoded LUKS UUIDs in configuration (lines 21, 29, 30)
- **[D9]**: Incomplete configuration - Most of the configuration is commented out, indicating unfinished setup

#### VM Workstation (machines/vm-workstation/default.nix) ⚠️
- **[Q26, Q27]**: Unused bindings - lib, config parameters not used (lines 1)
- **[Q28]**: Unused with statement - `with pkgs;` on line 36 but packages list is empty
- **[S15]**: Hardcoded network configuration - IP addresses and network interface hardcoded (lines 12, 17, 18)

#### Media Server (machines/media-server/default.nix) ⚠️
- **[Q29, Q30]**: Unused bindings - lib, pkgs parameters not used (lines 1)
- **[D10]**: Empty configuration - File is completely empty, indicating placeholder status

## 🔧 Additional Tool-Based Analysis

### Automated Nix Auditing Tools Results

#### deadnix Analysis (Dead Code Detection)
**Found 50+ additional unused declarations across the codebase:**

**Critical findings in flake.nix:**
- **[U1]**: Unused inputs: nixpkgs-unstable, nixos-hardware, nix-ld, nur
- **[D7]**: These unused inputs suggest missing functionality or incomplete refactoring

**Unused patterns discovered:**
- **[U2-U50]**: 48 additional unused lambda patterns/bindings across:
  - overlays/weechat.nix: unused 'self' parameter
  - overlays/default.nix: unused 'inputs' parameter  
  - All machine configurations: unused config, pkgs, lib parameters
  - All home-manager configurations: unused config, pkgs, lib parameters
  - Hardening modules: unused config, lib, pkgs parameters
  - Desktop modules: unused config, pkgs parameters

#### nix-instantiate Syntax Analysis
**Found critical syntax errors:**
- **[S12]**: Multiple files have incomplete expressions (syntax error, unexpected end of file)
- **[S13]**: Complex kernel configuration files may have parsing issues
- **[S14]**: nix-mineral security module has incomplete expressions

#### nix flake check Results
**Confirmed critical issues:**
- **[C2]**: `./modules/nixos` directory does not exist (flake.nix:84)
- **[C3]**: `./modules/home-manager` directory does not exist (flake.nix:87)  
- **[C5]**: These prevent the flake from being properly evaluated

### Code Quality Issues
- **[Q1-Q50]**: **Unused bindings**: Massive scope of unused declarations (50+ warnings detected):
  - Manual analysis found: [Q1-Q20] unused bindings in core files
  - **deadnix tool found**: [U2-U50] 48 additional unused lambda patterns across:
    - All machine configurations (unused config, pkgs, lib)
    - All home-manager configurations (unused config, pkgs, lib) 
    - All hardening modules (unused config, lib, pkgs)
    - overlays (unused inputs, self parameters)
- **[Q6, Q15]**: **Unused with statements**: common/desktop/default.nix and common/server/default.nix
- **[D1]**: **TODO comments**: Multiple TODOs indicate incomplete features
- **[U1]**: **Unused flake inputs**: nixpkgs-unstable, nixos-hardware, nix-ld, nur suggest missing functionality

### Dependency Management
- **Pinned versions**: Some inputs use specific commits, others use branches - inconsistent approach
- **Unused inputs**: Need to verify all inputs are actually used
- **Channel mixing**: Using both stable and unstable nixpkgs may cause conflicts

### Security & Hardening
- **[S1-S14]**: **Hardcoded paths & syntax issues**: Multiple hardcoded user paths and syntax errors:
  - common/core/default.nix: SOPS paths [S1]
  - common/home-manager/core/default.nix: SOPS paths [S4]
  - machines/gaming-desktop/default.nix: External drive paths [S6]
  - common/core/zsh/default.nix: Shell aliases [S9]
  - common/nix-on-droid/syncthing/default.nix: Android paths [S11]
  - **[S12-S14]**: Syntax errors in complex kernel/security configurations (nix-instantiate failures)
- **[S7]**: **Service security**: ollama service runs as regular user instead of dedicated service user
- **[S2, S5]**: **SOPS configuration**: Hardcoded paths for single user
- **[S3]**: **Hardcoded user**: "nebula" user hardcoded in desktop configuration
- **[S10]**: **Hardcoded user**: "library" user hardcoded in server configuration
- **[D3]**: **External dependencies**: Gaming desktop depends on external drive paths that may not be available
- **[M3]**: **Inconsistent security patterns**: Different hardening approaches across machines

### Performance & Optimization
- **[P1-P3]**: **Package bloat**: Large package lists in common configurations may include unnecessary software:
  - common/core/default.nix: Security tools on all systems [P1]
  - common/desktop/default.nix: Production systems with toy packages [P2]
  - common/home-manager/core/default.nix: 80+ packages [P3]
- **[D2, D6]**: **Configuration duplication**: Same settings repeated across multiple files (server vs desktop)
- **[M4]**: **Large closure sizes**: May be including unnecessary packages in system closures

## 📋 Recommended Improvements

### Immediate Actions (Critical)
1. **[C1]** Fix syntax errors in flake.nix - Line 284: `extraSpecialArgs = inputs { inherit inputs doomemacs; };`
2. **[C2]** Remove or implement missing module references - Lines 84, 87 reference non-existent modules
3. **[C4]** Clean up commented code blocks - Remove large commented home-manager sections in K3s configs
4. **[C3]** Fix broken import paths - Lines 310-311 reference non-existent `./home/base` and `./home/handheld`
5. **[Q1-Q20]** Clean up unused bindings - Remove unused function parameters across 20 files
6. **[S1, S3, S4, S6, S9, S11]** Fix hardcoded paths - Replace absolute paths with configurable alternatives

### Short-term Improvements
1. **[M5]** Standardize home-manager configuration patterns - Consistent approach across all machines
2. **[M6]** Create consistent naming conventions - Use consistent hyphen/underscore usage
3. **[M7]** Extract common patterns into reusable modules - Reduce duplication in common configs
4. **[M8]** Add proper documentation for structure - Guide for adding new machines
5. **[S8]** Implement proper user abstraction - Remove hardcoded "nebula" user
6. **[D2]** Fix configuration duplication - Remove duplicate locale/timezone settings
7. **[P1-P3]** Review and optimize package lists - Remove unnecessary packages

### Medium-term Refactoring
1. Implement proper module system for reusable components
2. Create machine templates for common patterns
3. Standardize security hardening across all machines
4. Optimize package sets and reduce closure sizes

### Long-term Architecture
1. Consider splitting into multiple flakes for different use cases
2. Implement proper testing framework
3. Add continuous integration for configuration validation
4. Create machine lifecycle management documentation

## 🎯 Best Practices Checklist

### ✅ What's Done Well
- **Good separation of concerns**: Clear separation between common and machine-specific configs
- **Use of flakes**: Proper reproducibility with flake-based configuration
- **SOPS integration**: Good secret management approach
- **Multiple device support**: Comprehensive support for desktop, server, mobile devices
- **Module structure**: Some well-structured modules like apparmor.nix
- **Overlay system**: Clean overlay implementation for custom packages

### ❌ What Needs Work
- **Code quality**: 9 linting warnings for unused bindings and statements
- **Multi-user support**: Hardcoded paths and user names prevent sharing
- **Error handling**: Missing validation for external dependencies
- **Configuration consistency**: Duplicated settings across files
- **Documentation**: Limited onboarding materials and structure guides
- **Testing**: No automated configuration validation
- **Security practices**: Some services run as regular users inappropriately

### 🔄 What to Implement
- **Automated configuration validation**: Pre-commit hooks or CI checks
- **Standardized machine addition workflow**: Template system for new machines
- **Security audit process**: Regular review of service configurations
- **Performance monitoring**: Track closure sizes and build times
- **Multi-user abstraction**: Configurable user names and home directories
- **Module extraction**: Pull common patterns into reusable modules
- **Documentation system**: Comprehensive guides for maintenance and extension

---

## 📊 Summary Statistics

### Configuration Scope
- **Total machines defined**: 11 NixOS configurations + 2 home-manager standalone + 1 Android
- **Common modules**: 50+ subdirectories with shared configurations
- **Custom overlays**: 1 overlay (weechat)
- **Security modules**: 1 custom AppArmor module
- **Linting issues**: 70+ total warnings (manual + automated analysis)
  - Manual analysis: 22 warnings
  - deadnix tool: 48+ additional unused declarations
  - Syntax errors: Multiple files with parsing issues

### Critical Issues Priority
1. **🚨 Critical**: [C1] Syntax errors preventing builds (flake.nix:284)
2. **🚨 Critical**: [C2, C3] Missing module directories preventing flake evaluation
3. **🚨 Critical**: [D4] Broken import paths in desktop-arm configuration
4. **🚨 Critical**: [S12-S14] Syntax errors in kernel/security configurations
5. **⚠️ High**: [S1, S3, S4, S6, S9, S11] Hardcoded paths preventing multi-user use
6. **⚠️ High**: [S7] Security issues with service user configuration
7. **📋 Medium**: [Q1-Q50] Massive code quality issues with unused declarations

### Automated Tool Results Summary
- **deadnix**: Found 48+ unused lambda patterns/bindings
- **nix-instantiate**: Found syntax errors in complex configurations
- **nix flake check**: Confirmed missing module directories
- **statix**: No additional issues (clean on best practices check)

### Issue Reference Guide
- **[C#]**: Critical issues that prevent builds or basic functionality
- **[S#]**: Security-related issues and concerns
- **[Q#]**: Code quality issues (unused bindings, linting)
- **[P#]**: Performance and package management issues
- **[D#]**: Duplication and consistency issues
- **[M#]**: Modularity and architectural issues

### Estimated Effort
- **Critical fixes**: 2-4 hours
- **Short-term improvements**: 1-2 days
- **Medium-term refactoring**: 1-2 weeks
- **Long-term architecture**: 1-2 months

---

*This document will be updated as improvements are made to the configuration.*