{ config, lib, pkgs, ... }:
{
  imports = [
    ./bash
    ./flatpak
    ./sxmo
    ./alacritty
  ];

  home = {
    username = "nebula";
    homeDirectory = "/home/nebula";

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
      # Mobile specific
      megapixels
      # wallet
      feather
      # Emacs dependencies:
      libtool
      cmake
      zstd
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
      signal-cli
      weechat
      vscodium
      # AI
      aichat
      yai
    ];

  }; # end home block

  home.file.".local/share/applications/firefox-flatpak-handler.desktop".source = ./firefox-flatpak-handler.desktop;

  xdg.mimeApps.defaultApplications = {
    "text/html" = "firefox-flatpak-handler.desktop";
    "x-scheme-handler/http" = "firefox-flatpak-handler.desktop";
    "x-scheme-handler/https" = "firefox-flatpak-handler.desktop";
    "x-scheme-handler/about" = "firefox-flatpak-handler.desktop";
  };

  home.sessionVariables = {
    XDG_DATA_DIRS = "$HOME/.nix-profile/share:$HOME/.share:/var/lib/flatpak/exports/share/:$HOME/.local/share/flatpak/exports/share/:$XDG_DATA_DIRS";
    LANG = "en_US.UTF-8";
    LC_TYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    XDG_CURRENT_DESKTOP = "sway";
    GTK_USE_PORTAL = "1";
  };

  programs.zsh.enable = true;

  programs.keepassxc = {
    enable = true;
    #autostart = true;
  };

  #services.pass-secret-service.enable = true;
  #services.gnome-keyring.enable = true;

  dconf.enable = true;

  # Required to install flatpak
  xdg.portal = {
    enable = true;
    config = {
      common = {
        default = [ "gtk" "wlr" ];
      };
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-termfilechooser
      xdg-desktop-portal-wlr
      # xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
  };

}
