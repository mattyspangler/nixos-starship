{ config, lib, pkgs, ... }:

{

  imports = [
    ./flatpak
    ./sway
    ./espanso
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = lib.mkDefault "nebula";
  home.homeDirectory = lib.mkDefault "/home/nebula";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    alacritty
    htop
    glances
    tmux
    zstd
    zsh
    fuse3
    cryptomator # not using flatpak because I need fuse3
    dia
    semantik
    # crypto stuff
    trezorctl
    trezord
    xmrig-mo
    monero-gui
    # development stuff
    nodejs
    nodePackages.npm
    vscodium
    distrobox
    podman-desktop
    (python3.withPackages (ps: with ps; [
        pip
        pandas
        requests
        ollama
        pygobject3
        # emigo dependencies
        #   github.com/MatthewZMD/emigo/blob/main/requirements.txt
        epc
        networkx
        pygments
        grep-ast
        diskcache
        tiktoken
        tqdm
        gitignore-parser
        scipy
        litellm
        orjson
    ]))
    gtk3 # Needed for GI
    gobject-introspection  # Required for GI repos

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  programs.bash = {
    shellAliases = {
      pip = "pip3";
    };
  };

  programs.zsh = {
    enable = true;
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
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/nebula/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "emacs";
    TERMINAL = "alacritty";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    #GTK_THEME = "";
    #QT_STYLE_OVERRIDE = "";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

}
