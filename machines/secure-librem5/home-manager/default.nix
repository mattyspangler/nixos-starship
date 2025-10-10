{ config, lib, pkgs, nixpkgs-unstable ? null, ... }:
let
  pkgs-unstable = if nixpkgs-unstable != null then
    import nixpkgs-unstable {
      system = pkgs.system;
      config = pkgs.config;
    }
  else
    pkgs; # fallback to stable if unstable not provided
in
{
  imports = [
    ./bash
    ./flatpak
    ./sxmo
    ./alacritty
    ./wofi
  ];

  home = {
    username = "nebula";
    homeDirectory = "/home/nebula";

    file.".profile".source = ./profile;

    file.".local/share/flatpak".source = config.lib.file.mkOutOfStoreSymlink "/run/media/nebula/SDCARD/flatpak";

    stateVersion = "24.05";
    packages = with pkgs; [
      zsh
      vim
      podman
      #waydroid # I need to use the postmarketos package to get the systemd additions
      alacritty
      mat2
      xdg-utils
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      gdb # gnu debugger, used by emigo for emacs
      dillo
      # Mobile specific
      megapixels
      # wallet
      homebank
      feather
      # Emacs dependencies:
      libtool
      cmake
      zstd
      libsecret
      # Security tools
      clamav
      clamtk
      lynis
      aide
      fail2ban
      gnupg
      pinentry-all
      pass
      keepassxc
      remind
      # gcr # used by gnome-keyring
      #ufw #not available?
      opensnitch
      #chrootkit #not available?
      #rkhunter #not available?
      profanity # cli xmpp client
      toot # mastodon cli client
      iamb # matrix client
      weechat
      newsboat # rss client
      castero # podcast client
      cmus # music client
      vscodium
      # AI
      aichat
      yai
      # Signal from unstable
      #pkgs-unstable.signal-cli
      #libsignal-ffi # https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal
    ];

  }; # end home block

  home.file.".local/share/applications/firefox-flatpak-handler.desktop".source = ./firefox-flatpak-handler.desktop;


  programs.zsh.enable = true;

  programs.keepassxc = {
    enable = true;
    #autostart = true;
  };

  #services.pass-secret-service.enable = true;
  #services.gnome-keyring.enable = true;

  dconf.enable = true;

  # Required to install flatpak
  xdg = {
    enable = true;
    mime.enable = true;
    portal = {
      enable = true;
      config = {
        common = {
          default = [ "gtk" "wlr" ];
        };
      };
      extraPortals = with pkgs; [
        #xdg-desktop-portal-termfilechooser
        xdg-desktop-portal-wlr
        # xdg-desktop-portal-kde
        xdg-desktop-portal-gtk
      ];
    }; # end portal block

    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "firefox-flatpak-handler.desktop";
        "x-scheme-handler/http" = "firefox-flatpak-handler.desktop";
        "x-scheme-handler/https" = "firefox-flatpak-handler.desktop";
        "x-scheme-handler/about" = "firefox-flatpak-handler.desktop";
      };
    };
  };

  # home.file.".local/bin/update_librem5" = {
  #   source = (config.home.homeDirectory + "/nixos-starship/update_librem5.sh");
  #   executable = true;
  # };

  # home.file.".local/bin/deploy_librem5_standalone" = {
  #   source = (config.home.homeDirectory + "/nixos-starship/deploy_librem5_standalone.sh");
  #   executable = true;
  # };

  services.podman = {
    enable = true;
  };

  systemd.user.services.signal-cli = {
    Unit = {
      Description = "Signal CLI REST API";
      After = [ "network.target" ];
    };

    Service = {
      Restart = "on-failure";
      ExecStartPre = ''
        ${pkgs.podman}/bin/podman pull docker.io/bbernhard/signal-cli-rest-api:latest
      '';
      ExecStart = ''
        ${pkgs.podman}/bin/podman run \
          --name signal-cli-rest-api \
          --rm \
          -p 8080:8080 \
          -v signal-cli-data:/home/.local/share/signal-cli \
          docker.io/bbernhard/signal-cli-rest-api:latest
      '';
      ExecStop = ''
        ${pkgs.podman}/bin/podman stop signal-cli-rest-api
      '';
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
