{ pkgs, ... }:

{
  home.sessionVariables = {
    FLATPAK_USER_DIR = "/run/media/nebula/SDCARD/flatpak";
  };

  home.file.".profile".text = ''
    # Unlock and mount SD card in the background
    $HOME/.local/bin/unlock-sd-card.sh &
  '';

  home.file.".local/bin/unlock-sd-card.sh" = {
    source = ../scripts/unlock-sd-card.sh;
    executable = true;
  };
}