{ config, lib, pkgs, ... }:
let
  gnome-keyring-daemon-wrapped = pkgs.writeShellScriptBin "gnome-keyring-daemon" ''
    #!${pkgs.runtimeShell}
    # postmarketos has issues with ambient capabilities
    # https://gitlab.postmarketos.org/postmarketOS/pmaports/-/issues/3868
    exec ${pkgs.util-linux}/bin/setpriv --ambient-caps '-all' ${pkgs.gnome-keyring}/bin/gnome-keyring-daemon "$@"
  '';
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

  systemd.user.services = {
    "gnome-keyring-secrets".Service.ExecStart =
      lib.mkForce "${gnome-keyring-daemon-wrapped}/bin/gnome-keyring-daemon --foreground --components=secrets";
    "gnome-keyring-ssh".Service.ExecStart =
      lib.mkForce "${gnome-keyring-daemon-wrapped}/bin/gnome-keyring-daemon --foreground --components=ssh";
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
