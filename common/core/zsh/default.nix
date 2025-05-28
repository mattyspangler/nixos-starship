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
