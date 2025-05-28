{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    <nixpkgs/nixos/modules/profiles/base.nix>
    <nixpkgs/nixos/modules/installer/sd-card/sd-image.nix>
    "${builtins.fetchGit {url = "https://github.com/NixOS/nixos-hardware.git";}}/raspberry-pi/4"
    ./kernel
    ../raspberry-pi/overlays
    ../raspberry-pi/apply-overlays
  ];

  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // {allowMissing = true;});
    })
  ];

  nix.settings = {
    substituters = ["https://cache-nix.project2.xyz/uconsole"];
    trusted-substituters = ["https://cache-nix.project2.xyz/uconsole"];
    trusted-public-keys = ["uconsole:t2pv3NWEtXCYY0fgv9BB8r9tRdK+Tz7HYhGq9bXIIck="];
  };

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.supportedFilesystems.zfs = lib.mkForce false;

  boot.consoleLogLevel = lib.mkDefault 7;

  users.users.root.initialPassword = "";

  console = {
    earlySetup = true;
    font = "ter-v32n";
    packages = with pkgs; [terminus_font];
  };

  boot.kernelParams = [
    "8250.nr_uarts=1"
    "vc_mem.mem_base=0x3ec00000"
    "vc_mem.mem_size=0x20000000"
    "console=ttyS0,115200"
    "console=tty1"
    "plymouth.ignore-serial-consoles"
    "snd_bcm2835.enable_hdmi=1"
    "snd_bcm2835.enable_headphones=1"
    "psi=1"
    "iommu=force"
    "iomem=relaxed"
    "swiotlb=131072"
  ];

  system.stateVersion = "24.11";
  hardware.raspberry-pi."4" = {
    xhci.enable = false;
    dwc2.enable = true;
    dwc2.dr_mode = "host";
    overlays = {
      cpu-revision.enable = true;
      audremap.enable = true;
      vc4-kms-v3d.enable = true;
      cpi-disable-pcie.enable = true;
      cpi-disable-genet.enable = true;
      cpi-uconsole.enable = true;
      cpi-i2c1.enable = false;
      cpi-spi4.enable = false;
      cpi-bluetooth.enable = true;
    };
  };

  hardware.deviceTree = {
    enable = true;
    filter = "bcm2711-rpi-cm4.dtb";
    overlaysParams = [
      {
        name = "bcm2711-rpi-cm4";
        params = {
          ant2 = "on";
          audio = "on";
          spi = "off";
          i2c_arm = "on";
        };
      }
      {
        name = "cpu-revision";
        params = {cm4-8 = "on";};
      }
      {
        name = "audremap";
        params = {pins_12_13 = "on";};
      }
      {
        name = "vc4-kms-v3d";
        params = {
          cma-384 = "on";
          nohdmi1 = "on";
        };
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    wirelesstools
    iw
    gitMinimal
    wpa_supplicant
    eiwd
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  sdImage = {
    compressImage = false;
    populateFirmwareCommands = let
      configTxt = pkgs.writeText "config.txt" ''
        [pi4]
        kernel=u-boot-rpi4.bin
        enable_gic=1
        armstub=armstub8-gic.bin

        [all]
        arm_64bit=1
        enable_uart=1
        avoid_warnings=1
        gpio=10=ip,np
        gpio=11=op
        arm_boost=1

        over_voltage=6
        arm_freq=2000
        gpu_freq=750

        display_auto_detect=1
        ignore_lcd=1
        disable_fw_kms_setup=1
        disable_audio_dither=1
        pwm_sample_bits=20
      '';
    in ''
      (cd ${pkgs.raspberrypifw}/share/raspberrypi/boot && cp bootcode.bin fixup*.dat start*.elf $NIX_BUILD_TOP/firmware/)

      # Add the config
      cp ${configTxt} firmware/config.txt

      # Add pi4 specific files
      cp ${pkgs.ubootRaspberryPi4_64bit}/u-boot.bin firmware/u-boot-rpi4.bin
      cp ${pkgs.raspberrypi-armstubs}/armstub8-gic.bin firmware/armstub8-gic.bin
      cp ${pkgs.raspberrypifw}/share/raspberrypi/boot/bcm2711-rpi-cm4.dtb firmware/
    '';
    populateRootCommands = ''
      mkdir -p ./files/boot
      mkdir -p ./files/boot/firmware
      mkdir -p ./files/etc/nixos
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
      cp ${./configs}/* ./files/etc/nixos
    '';
  };
}
