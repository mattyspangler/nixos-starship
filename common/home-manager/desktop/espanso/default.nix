{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    espanso-wayland
    git  # Required for submodule management
    # We'll rely on the system's Python environment
    # which already has litellm installed
  ];
  
  # Espanso configuration
  home.file = {
    # Ensure config directory exists
    ".config/espanso/.keep".text = "";
    
    # LiteLLM expander
    ".config/espanso/litellm_config.yaml" = {
      source = ./packages/litellm-expander/default_config.yaml;
      onChange = ''
        # Only copy if the file doesn't exist already
        if [ ! -f "$HOME/.config/espanso/litellm_config.yaml" ]; then
          cp ${./packages/litellm-expander/default_config.yaml} $HOME/.config/espanso/litellm_config.yaml
        fi
      '';
    };
    
    # Set up symlinks to the git submodules
    # These will automatically stay up to date when you run:
    # git submodule update --remote
    ".config/espanso/packages/python-expander".source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos-starship/common/home-manager/desktop/espanso/packages/python-expander";
    
    ".config/espanso/packages/k8s-expander".source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos-starship/common/home-manager/desktop/espanso/packages/k8s-expander";
    
    ".config/espanso/packages/bash-expander".source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos-starship/common/home-manager/desktop/espanso/packages/bash-expander";
    
    # Symlink our litellm-expander package too
    ".config/espanso/packages/litellm-expander".source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos-starship/common/home-manager/desktop/espanso/packages/litellm-expander";
  };
  
  # Make scripts executable
  home.activation.makeEspansoScriptsExecutable = lib.hm.dag.entryAfter ["writeBoundary"] ''
    chmod +x $HOME/.config/espanso/packages/litellm-expander/litellm_expander.py 2>/dev/null || true
  '';
}
