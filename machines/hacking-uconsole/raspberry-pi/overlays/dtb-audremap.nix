{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge mkOption types;
  cfg = config.hardware.raspberry-pi."4".overlays.audremap;
in {
  options.hardware.raspberry-pi."4".overlays.audremap = {
    enable = mkEnableOption ''overlay enable'';
    name = mkOption {
      type = types.str;
      default = "audremap";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      hardware.deviceTree.overlays = [
        {
          name = "${cfg.name}";
          filter = "bcm2711-rpi-*.dtb";
          dtsFile = ./source/audremap.dts;
        }
      ];
    })
  ];
}
