{ lib, config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = lib.mkDefault "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Ports for SSH and Syncthing
  networking.firewall.allowedTCPPorts = [
    22 # SSH
    8384 # Syncthing UI
    22000 # Syncthing transfer
    6443 # used by pods to reach k3s API server
    2379 # etcd clients, for HA
    2380 # etcd peers, for HA
    80 # Rancher UI/API
    443 # Rancher; Rancher agent/UI/API/kubectl
    102 # Rancher; kubelet
    50 # Rancher; kubelet
  ];
  networking.firewall.allowedUDPPorts = [
    22000 # Syncthing transfer
    8472 # k3s flannel, required if using multi-node for inter-node networking
  ];

  # Enable SSH
  services.openssh.enable = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = lib.mkDefault true;

  networking = {
    interfaces = lib.mkDefault {
      ens18.ipv4.addresses = [{
        address = "192.168.100.101";
        prefixLength = 24;
      }];
    };
    defaultGateway = lib.mkDefault {
      address = "192.168.100.1";
      interface = "ens18";
    };
    nameservers = lib.mkDefault ["1.1.1.1"];
  };

}
