{ config, lib, pkgs, ... }:
let
  #This is a wrapper for the gnome-keyring-daemon that adds IPC_LOCK capability.
  # https://github.com/NixOS/nixpkgs/blob/3d2d8f281a27d466fa54b469b5993f7dde198375/nixos/modules/services/desktops/gnome3/gnome-keyring.nix#L46
  # https://github.com/nix-community/home-manager/issues/1454
  # https://man7.org/linux/man-pages/man2/mlock.2.html
  # https://github.com/GNOME/gnome-keyring/blob/main/daemon/gkd-capability.c
  # The issue is we get a `insufficient process capabilities, insecure memory might get used` error when running flatpak apps like Tuba that need gnome-keyring
  # We already drop ambient capabilities for flatpak so we need to add a wrapper for gnome-keyring to add the IPC_LOCK capability.
  # This is a common issue on systems where user sessions don't get this capability by default.
  gnome-keyring-wrapped = import ./gnome-keyring-wrapper.nix { inherit pkgs; };
in
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
      mat2
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
      # Secret service for Tuba and other apps
      gnome-keyring-wrapped
    ];

  }; # end home block

  home.sessionVariables = {
    XDG_DATA_DIRS = "$HOME/.local/share/flatpak/exports/share:$XDG_DATA_DIRS";
    LANG = "en_US.UTF-8";
    LC_TYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    XDG_CURRENT_DESKTOP = "sway";
    GTK_USE_PORTAL = "1";
  };

  programs.zsh.enable = true;

  services.gnome-keyring = {
    enable = true;
    components = [ "secrets" "ssh" ];
  };

  # Required to install flatpak
  xdg.portal = {
    enable = true;
    config = {
      common = {
        default = [ "wlr" "gtk" ];
      };
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      # xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
  };

}
