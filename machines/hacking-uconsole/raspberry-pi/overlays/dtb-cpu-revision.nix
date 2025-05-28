{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge mkOption types;
  cfg = config.hardware.raspberry-pi."4".overlays.cpu-revision;
in {
  options.hardware.raspberry-pi."4".overlays.cpu-revision = {
    enable = mkEnableOption ''overlay enable'';
    name = mkOption {
      type = types.str;
      default = "cpu-revision";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      hardware.deviceTree = {
        overlays = [
          {
            name = "${cfg.name}";
            filter = "bcm2711-rpi-*.dtb";
            dtsFile = ./source/cpu-revision.dts;
          }
        ];
      };
    })
  ];
}
