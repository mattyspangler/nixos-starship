{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge mkOption types;
  cfg = config.hardware.raspberry-pi."4".overlays.cpi-uconsole;
in {
  options.hardware.raspberry-pi."4".overlays.cpi-uconsole = {
    enable = mkEnableOption ''overlay enable'';
    name = mkOption {
      type = types.str;
      default = "cpi-uconsole";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      hardware.deviceTree = {
        overlays = [
          {
            name = "${cfg.name}";
            filter = "bcm2711-rpi-cm4.dtb";
            dtsFile = ./source/cpi-uconsole.dts;
          }
        ];
      };
    })
  ];
}
