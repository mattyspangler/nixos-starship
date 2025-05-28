{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge mkOption types;
  cfg = config.hardware.raspberry-pi."4".overlays.rpi4-disable-pwrled;
in {
  options.hardware.raspberry-pi."4".overlays.rpi4-disable-pwrled = {
    enable = mkEnableOption ''overlay enable'';
    name = mkOption {
      type = types.str;
      default = "rpi4-disable-pwrled";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      hardware.deviceTree = {
        overlays = [
          {
            name = "${cfg.name}";
            filter = "bcm2711-rpi-4-b.dtb";
            dtsFile = ./source/rpi4-disable-pwrled.dts;
          }
        ];
      };
    })
  ];
}
