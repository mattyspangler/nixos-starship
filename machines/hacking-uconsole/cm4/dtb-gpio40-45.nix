{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge;
  cfg = config.hardware.raspberry-pi."4".overlays;
in {
  options.hardware = {
    raspberry-pi."4".overlays.spi-gpio40-45.enable = mkEnableOption ''spi-gpio40-45 enable '';
  };

  config = mkMerge [
    (mkIf cfg.spi-gpio40-45.enable {
      hardware.deviceTree = {
        overlays = [
          {
            name = "spi-gpio40-45.overlay";
            filter = "*rpi-cm4*";
            dtsText = ''
              /dts-v1/;
              /plugin/;
              / {
                compatible = "brcm,bcm2711";
                fragment@0 {
                  target = <&spi0>;
                  __overlay__ {
                    cs-gpios = <&gpio 43 1>, <&gpio 44 1>, <&gpio 45 1>;
                    status = "okay";
                  };
                };
                fragment@1 {
                  target = <&spi0_cs_pins>;
                  __overlay__ {
                    brcm,pins = <45 44 43>;
                    brcm,function = <1>; /* output */
                    status = "okay";
                  };
                };
                fragment@2 {
                  target = <&spi0_pins>;
                  __overlay__ {
                    brcm,pins = <40 41 42>;
                    brcm,function = <3>; /* alt4 */
                    status = "okay";
                  };
                };
              };
            '';
          }
        ];
      };
    })
  ];
}
