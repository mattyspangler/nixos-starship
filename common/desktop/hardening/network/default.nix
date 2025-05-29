{ pkgs, ... }: 
{

  # Enable firewall and block all ports:
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [];
    allowedUDPPorts = [];
  };

}
