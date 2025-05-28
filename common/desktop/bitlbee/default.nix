{ pkgs, ... }:
{

  nixpkgs.config.bitlbee.enableLibPurple = true;

  services.bitlbee = {
    enable = true;
    plugins = with pkgs; [
      bitlbee-facebook
      bitlbee-discord # I had issues with this so I switched to purple-discord
      bitlbee-mastodon
      bitlbee-steam
    ];
    libpurple_plugins = with pkgs; [
      purple-discord
    ];
    authMode = "Registered";
    portNumber = 6667;
    interface = "127.0.0.1";
  };

  networking.firewall.allowedTCPPorts = [ 6667 ];

  environment.systemPackages = with pkgs; [
    bitlbee
  ];

}
