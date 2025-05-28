{
  nixos-hardware,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkDefault;
  cfg = config.hardware.deskpi;
in {
  options.hardware.deskpi = {
    enable = mkEnableOption "enable DeskPi Pro daemons";
    device = mkOption {
      type = types.str;
      default = "/dev/deskPi";
    };
  };

  imports =
    [nixos-hardware.nixosModules.raspberry-pi-4]
    ++ [../raspberry-pi/overlays]
    ++ [../raspberry-pi/apply-overlays]
    ++ [./deskpi-tools.nix]
    ++ [./trim.nix];

  config = {
    hardware.raspberry-pi."4" = {
      xhci.enable = mkDefault false;
      dwc2.enable = mkDefault true;
      dwc2.dr_mode = mkDefault "host";
      overlays = {
        rpi4-disable-pwrled.enable = mkDefault true;
      };
    };

    hardware.deviceTree = {
      enable = true;
      filter = "bcm2711-rpi-4-b.dtb";
    };

    services.udev.extraRules = ''
      ACTION=="add", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="7523", SUBSYSTEM=="tty", SYMLINK+="${builtins.baseNameOf cfg.device}"
    '';
  };
}
