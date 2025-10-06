{ pkgs, ... }:

let
  sdCardMount = ''
    # Mount SD card for Flatpak
    if [ -b /dev/sda1 ]; then
      LUKS_PASSWORD=$(secret-tool lookup luks-sdcard /dev/sda1)
      if [ -n "$LUKS_PASSWORD" ]; then
        echo "$LUKS_PASSWORD" | cryptsetup luksOpen /dev/sda1 sdcard_luks --key-file -
        mkdir -p /run/media/nebula/SDCARD
        mount /dev/mapper/sdcard_luks /run/media/nebula/SDCARD || true
        mkdir -p /run/media/nebula/SDCARD/flatpak
      fi
    fi
  '';
in
{
  home.sessionVariables = {
    FLATPAK_USER_DIR = "/run/media/nebula/SDCARD/flatpak";
  };

}