{ lib, config, pkgs, ... }:

{

  networking.hostName = "alexandria3";

  networking = {
    interfaces = {
      ens18.ipv4.addresses = [{
        address = "192.168.100.103";
        prefixLength = 24;
      }];
    };
  };

  services.k3s = {
    enable = true;
    role = "agent";
    # TODO: figure out how to inject sops-nix secrets
    token = "";
    serverAddr = "https://192.168.100.101:6443";
  };

}
