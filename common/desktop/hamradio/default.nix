{ pkgs, ... }:

{
  services.udev.extraRules = builtins.readFile ./radio.rules;
  
  environment.systemPackages = with pkgs; [
    qdmr
    dmrconfig
    chirp
  ];
}