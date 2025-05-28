{ lib, config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  networking.hostName = "gaming-desktop";

  services.ollama = {
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
