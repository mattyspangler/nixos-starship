{ ... }:
{

  # Enable firewall and block all ports:
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [];
  networking.firewall.allowedUDPPorts = [];

}
