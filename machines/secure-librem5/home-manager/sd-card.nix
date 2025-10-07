{ pkgs, ... }:

{
  home.sessionVariables = {
    FLATPAK_USER_DIR = "/run/media/nebula/SDCARD/flatpak";
  };
}