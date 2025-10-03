{ config, lib, pkgs, ... }:
{
  imports = [
    ./bash
    ./flatpak
    ./sxmo
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

  home.sessionVariables = {
    XDG_DATA_DIRS = "$HOME/.local/share/flatpak/exports/share:$XDG_DATA_DIRS";
    LANG = "en_US.UTF-8";
    LC_TYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };

  programs.zsh.enable = true;

  # Required to install flatpak
  xdg.portal = {
    enable = true;
    config = {
      common = {
        default = [
          "gtk"
        ];
      };
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      #      xdg-desktop-portal-kde
      #      xdg-desktop-portal-gtk
    ];
  };

}
