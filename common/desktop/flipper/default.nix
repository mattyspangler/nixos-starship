{ pkgs, ... }:

{
  services.udev.extraRules = builtins.readFile ./50-flipper-zero.rules;
  
  environment.systemPackages = with pkgs; [
    qflipper
  ];
}