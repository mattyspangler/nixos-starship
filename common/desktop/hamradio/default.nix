{ pkgs, ... }:

{
  #services.udev.extraRules = builtins.readFile ./.rules;
  
  environment.systemPackages = with pkgs; [
    qdmr
  ];
}