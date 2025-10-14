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

    # flatpak
    file.".local/share/flatpak".source = config.lib.file.mkOutOfStoreSymlink "/run/media/nebula/SDCARD/flatpak";
    file.".var/app".source = config.lib.file.mkOutOfStoreSymlink "/run/media/nebula/SDCARD/flatpak-var-app";
    # waydroid
    file.".local/share/waydroid".source = config.lib.file.mkOutOfStoreSymlink "/run/media/nebula/SDCARD/waydroid";
    file."/var/lib/waydroid".source = config.lib.file.mkOutOfStoreSymlink "/run/media/nebula/SDCARD/waydroid-system";
    # user dirs
    file."Documents".source = config.lib.file.mkOutOfStoreSymlink "/run/media/nebula/SDCARD/Documents";
    file."Music".source = config.lib.file.mkOutOfStoreSymlink "/run/media/nebula/SDCARD/Music";
    file."Downloads".source = config.lib.file.mkOutOfStoreSymlink "/run/media/nebula/SDCARD/Downloads";


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
      swaylock
      gdb # gnu debugger, used by emigo for emacs
      dillo
      at
      tty-clock
      remind
      wyrd # frontend for rewind
      calcurse
      # Mobile specific
      megapixels
      geoclue2
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
      # gcr # used by gnome-keyring
      #ufw #not available?
      opensnitch
      #chrootkit #not available?
      #rkhunter #not available?
      profanity # cli xmpp client
      gurk-rs # signal client
      toot # mastodon cli client
      iamb # matrix client
      weechat
      tuisky # bluesky client
      newsboat # rss client
      castero # podcast client
      cmus # music client
      ranger # terminal file manager
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
          default = [ "termfilechooser" "wlr" "gtk" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
        };
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-termfilechooser
        xdg-desktop-portal-wlr
        #xdg-desktop-portal-kde
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

}
