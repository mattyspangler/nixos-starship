{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption types;
  cfg = config.hardware.deskpi.trim;
in {
  options.hardware.deskpi.trim = {
    enable = mkEnableOption "enable uas fstrim support";
  };
  config = mkIf cfg.enable {
    services.udev.extraRules = ''
      ACTION=="add|change", ATTRS{idVendor}=="174c", ATTRS{idProduct}=="55aa", SUBSYSTEM=="scsi_disk", ATTR{provisioning_mode}="unmap"
    '';
  };
}
