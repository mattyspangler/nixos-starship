{ config, lib, pkgs, ... }:

{
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
          "z"
          "history"
        "npm"
        "node"
        "rust"
        "deno"
        ];
      };
      shellAliases = {
        ll = "ls -la";
        pip = "pip3";
        nrs-gaming-desktop = "sudo nixos-rebuild switch --flake ~/nix-config/#gaming-desktop --option binary-caches-parallel-connections 5";
        der = "~/.config/emacs/bin/doom build && ~/.config/emacs/bin/doom sync";
        des = "~/.config/emacs/bin/doom sync";
      };
      initContent = ''
        eval "$(starship init zsh)"
        export OPENAI_API_KEY=$(cat ${config.sops.secrets."nano-gpt_key".path})
      '';
    }; # end zsh block

    starship = {
      enable = true;
    }; # end starship block

  }; # end programs block

  home.packages = with pkgs; [
    zsh
    oh-my-zsh
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-history-substring-search
    starship
  ];

}
