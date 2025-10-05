{ config, lib, pkgs, ... }:

{
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
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
        nrs-gaming-desktop = "sudo nixos-rebuild switch --flake ~/nixos-starship/#gaming-desktop --option binary-caches-parallel-connections 5";
        hms-librem = "~/nixos-starship/deploy_librem5_standalone.sh";
        der = "~/.config/emacs/bin/doom build && ~/.config/emacs/bin/doom sync";
        des = "~/.config/emacs/bin/doom sync";
      };
      initContent = ''
        export LANG="en_US.UTF-8"
        export LC_CTYPE="en_US.UTF-8"
        export LC_ALL="en_US.UTF-8"
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
