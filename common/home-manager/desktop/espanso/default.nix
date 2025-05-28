{ config, lib, pkgs, ... }:
{

  home.packages = with pkgs; [
    espanso-wayland
  ];



}
