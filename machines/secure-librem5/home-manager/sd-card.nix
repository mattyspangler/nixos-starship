{ pkgs, ... }:

{
  home.file.".profile".text = ''
    export FLATPAK_USER_DIR="/run/media/nebula/SDCARD/flatpak"
  '';
}