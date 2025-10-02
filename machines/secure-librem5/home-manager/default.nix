{ config, lib, pkgs, ... }:
{
  imports = [
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
      #flatpak
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
    ];

  }; # end home block

  programs.zsh.enable = true;

  # systemd.user.services.flatpak-managed-install.serviceConfig.Environment = [
  #  "HOME=${config.home.homeDirectory}"
  #];
}
