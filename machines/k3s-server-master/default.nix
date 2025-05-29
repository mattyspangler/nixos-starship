{ config, pkgs, ... }:

{

  networking = {
    networkmanager.enable = true;
    hostName = "alexandria1";
    interfaces = {
      ens18.ipv4.addresses = [{
        address = "192.168.100.101";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "192.168.100.1";
      interface = "ens18";
    };
    nameservers = ["1.1.1.1"];
  };

  # If this is enabled seperately alongside k3s, I get a k3s.service failure to bind to 127.0.0.1:2380
  # Nonetheless, keeping it here because uncommenting it is useful for resetting the cluster!
  #services.etcd.enable = true;

  services.k3s = {
    enable = true;
    role = "server";
    # TODO: figure out how to inject sops-nix secrets
    token = "";
    clusterInit = true;
  };

}
