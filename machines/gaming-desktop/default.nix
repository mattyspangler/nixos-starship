{ lib, config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
    
  # Bootloader.
  boot = lib.mkDefault {
    loader = lib.mkDefault { 
      systemd-boot.enable = lib.mkDefault true;
      efi.canTouchEfiVariables = lib.mkDefault true;

      # Reduce disk usage
      # Limit the number of generations to keep
      systemd-boot.configurationLimit = lib.mkDefault 15;
      # grub.configurationLimit = 10;
    };

    # So I can compile for other architectures
    binfmt.emulatedSystems = [ "aarch64-linux" ];

  };
  
  networking.hostName = "gaming-desktop";

  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    home = lib.mkForce "/run/media/nebula/SpaceDandy/ollama";
    models = lib.mkForce "/run/media/nebula/SpaceDandy/ollama/models";
    acceleration = "rocm";
    environmentVariables = {
      HOME = lib.mkForce "/run/media/nebula/SpaceDandy/ollama";
      OLLAMA_MODELS = lib.mkForce "/run/media/nebula/SpaceDandy/ollama/models";
      HSA_OVERRIDE_GFX_VERSION = "11.0.0";
    };
  };

  systemd.services.ollama = {
    after = [ "network.target" ];
    serviceConfig = {
      StateDirectory = lib.mkForce "";
      WorkingDirectory = lib.mkForce "/run/media/nebula/SpaceDandy/ollama";
      #User = "ollama";
      User = "nebula";
      Group = "ollama";
      # Allow access through group permissions
      UMask = lib.mkForce "0002";
    };
  };

}
