{ config, lib, pkgs, ... }:
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
      waydroid
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
      toot # mastodon cli client
      iamb # matrix client
      weechat
      vscodium
      # AI
      aichat
      yai
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

}
