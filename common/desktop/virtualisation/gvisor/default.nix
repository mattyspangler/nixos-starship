{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    gvisor
  ];

  virtualisation.containers.containersConf.settings = {
    engine = {
      runtime = "runsc";
    };
  };
}
