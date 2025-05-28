{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{

  imports = [
    ./syncthing
  ];

  #environment.systemPackages = with pkgs; [
  #];

}
