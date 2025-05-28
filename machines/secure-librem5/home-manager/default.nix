{ config, lib, pkgs, ... }:
{
  imports = [
    ./flatpak
  ];

  home.username = "purism";
  home.homeDirectory = "/home/purism";

  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    zsh
    vim
    podman
    waydroid
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
  ];

  programs.zsh.enable = true;

}
