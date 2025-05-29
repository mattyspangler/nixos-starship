{ config, pkgs, ... } : {

  # for global user
  users.defaultUserShell=pkgs.zsh;

  # enable zsh and oh my zsh
  programs = {
    zsh = {

        enable = true;
        autosuggestions.enable = true;
        zsh-autoenv.enable = true;
        syntaxHighlighting.enable = true;

        shellAliases = {
          pip = "pip3";
          # I hate working with long nixos rebuild commands!
          # Mnemonic: nrs = nixos-rebuild + switch
          nrs-gaming-desktop = "sudo nixos-rebuild switch --flake ~/nix-config/#gaming-desktop --option binary-caches-parallel-connections 5";
          # Emacs shortcuts
          # Mnemonic: der = doom emacs rebuild; des -> doom emacs sync
          der = "~/.config/emacs/bin/doom build && ~/.config/emacs/bin/doom sync";
          des = "~/.config/emacs/bin/doom sync";
        };

        ohMyZsh = {
          enable = true;
          theme = "robbyrussell";
          plugins = [
            "git"
            "npm"
            "history"
            "node"
            "rust"
            "deno"
          ];
        };
        
    };
  };

}
