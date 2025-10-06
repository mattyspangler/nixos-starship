{ pkgs, ... }:

{
  home.sessionVariables = {
    FLATPAK_USER_DIR = "/run/media/nebula/SDCARD/flatpak";
  };

  home.file.".profile".text = ''
    # Unlock and mount SD card in the background
    ${pkgs.buildEnv { name = "unlock-sd-card-script"; paths = [ pkgs.coreutils pkgs.flatpak pkgs.libsecret pkgs.cryptsetup ]; }}/bin/unlock-sd-card.sh &
  '';

  home.file.".local/bin/unlock-sd-card.sh" = {
    source = ../scripts/unlock-sd-card.sh;
    executable = true;
  };
}