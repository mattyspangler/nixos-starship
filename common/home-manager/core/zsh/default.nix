{ config, lib, pkgs, ... }:

let
  aliases = import ../aliases.nix;
in {
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
      shellAliases = aliases;
      initContent = ''
        # Source home-manager session variables
        if [ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
          . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
        fi

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
