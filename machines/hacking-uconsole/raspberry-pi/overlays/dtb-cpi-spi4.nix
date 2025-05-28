{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge mkOption types;
  cfg = config.hardware.raspberry-pi."4".overlays.cpi-spi4;
in {
  options.hardware.raspberry-pi."4".overlays.cpi-spi4 = {
    enable = mkEnableOption ''overlay enable'';
    name = mkOption {
      type = types.str;
      default = "cpi-spi4";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      hardware.deviceTree = {
        overlays = [
          {
            name = "${cfg.name}";
            filter = "bcm2711-rpi-cm4.dtb";
            dtsFile = ./source/cpi-spi4.dts;
          }
        ];
      };
    })
  ];
}
