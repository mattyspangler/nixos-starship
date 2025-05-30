{ config, pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    yabridge
    yabridgectl
    renoise
  ];

}