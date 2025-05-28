{
  config,
  lib,
  fn,
  nixos-hardware,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.hardware.cm4;
in {
  options.hardware.cm4 = {
    enable = mkEnableOption "custom CM4";
  };

  imports = [nixos-hardware.nixosModules.raspberry-pi-4] ++ (fn.scanPaths ./.);

  config = mkIf cfg.enable {
    hardware.raspberry-pi."4" = {
      apply-overlays-dtmerge.enable = true;
      xhci.enable = true;
      overlays = {
        audremap.enable = true;
        spi-gpio40-45.enable = true;
      };
    };

    hardware.deviceTree = {
      enable = true;
      filter = "*-rpi-cm4.dtb";
    };

    users.groups.spi = {};
    services.udev.extraRules = ''
      SUBSYSTEM=="spidev", KERNEL=="spidev0.0", GROUP="spi", MODE="0660"
    '';
  };
}
