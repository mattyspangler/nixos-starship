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
    #file."/var/lib/waydroid".source = config.lib.file.mkOutOfStoreSymlink "/run/media/nebula/SDCARD/waydroid-system"; # I may need a systemd service for this one
    # user dirs
    file."Documents".source = config.lib.file.mkOutOfStoreSymlink "/run/media/nebula/SDCARD/Documents";
    file."Music".source = config.lib.file.mkOutOfStoreSymlink "/run/media/nebula/SDCARD/Music";
    file."Downloads".source = config.lib.file.mkOutOfStoreSymlink "/run/media/nebula/SDCARD/Downloads";

    stateVersion = "24.05";
    packages = with pkgs; [
      aide
      aichat
      alacritty
      at
      calcurse
      castero
      clamav
      clamtk
      cmake
      cmus
      dillo
      fail2ban
      feather
      fzf
      gdb # gnu debugger, used by emigo for emacs
      geoclue2
      gnupg
      gurk-rs # signal client
      homebank
      iamb # matrix client
      keepassxc
      libsecret
      libtool
      lynis
      lynx
      macchanger
      mat2
      megapixels
      nerd-fonts.droid-sans-mono
      nerd-fonts.fira-code
      nerd-fonts.hack
      newsboat # rss client
      newsraft # lighter rss client
      opensnitch
      pass
      pcscliteWithPolkit # needed for nitrokey and keepassxc
      #pidgin opting for flatpak
      pinentry-all
      podman
      profanity # cli xmpp client
      protonmail-bridge
      ranger # terminal file manager
      remind
      rsync
      swaylock
      sqlite # used to read firefox bookmarks
      toot # mastodon cli client
      tty-clock
      tuisky # bluesky client
      viu # cli image viewer
      vim
      vscodium
      weechat
      wyrd # frontend for rewind
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-utils
      yai
      zsh
      zstd
      #waydroid # I need to use the postmarketos package to get the systemd additions
      #ufw #not available?
      #chrootkit #not available?
      #rkhunter #not available?
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

  #services.pcscd = {
  #  enable = true;
  #};

}
