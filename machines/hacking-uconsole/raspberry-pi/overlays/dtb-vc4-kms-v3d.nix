{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge mkOption types;
  cfg = config.hardware.raspberry-pi."4".overlays.vc4-kms-v3d;
in {
  options.hardware.raspberry-pi."4".overlays.vc4-kms-v3d = {
    enable = mkEnableOption ''overlay enable'';
    name = mkOption {
      type = types.str;
      default = "vc4-kms-v3d";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      hardware.deviceTree = {
        overlays = [
          {
            name = "${cfg.name}";
            filter = "bcm2711-rpi-*.dtb";
            dtsFile = ./source/vc4-kms-v3d.dts;
          }
        ];
      };
    })
  ];
}
