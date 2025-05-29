{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "docker"
        "z"
        "history"
      "npm"
      "node"
      "rust"
      "deno"
      ];
      theme = "spaceship";
    };
    shellAliases = {
      ll = "ls -la";
      pip = "pip3";
      nrs-gaming-desktop = "sudo nixos-rebuild switch --flake ~/nix-config/#gaming-desktop --option binary-caches-parallel-connections 5";
      der = "~/.config/emacs/bin/doom build && ~/.config/emacs/bin/doom sync";
      des = "~/.config/emacs/bin/doom sync";
    };
    initContent = ''
      SPACESHIP_PROMPT_ADD_NEWLINE="true"
      SPACESHIP_PROMPT_SEPARATE_LINE="true"
      SPACESHIP_CHAR_SYMBOL="❯"
      SPACESHIP_CHAR_SUFFIX=" "
      export OPENAI_API_KEY=$(cat ${config.sops.secrets."nano-gpt_key".path})
    '';
  };

  home.packages = with pkgs; [
    zsh
    oh-my-zsh
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-history-substring-search
    spaceship-prompt
  ];
}
