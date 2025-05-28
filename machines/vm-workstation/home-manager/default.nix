{ config, lib, pkgs, ... }:
{
  home.username = lib.mkForce "library";
  home.homeDirectory = lib.mkForce "/home/library";
}
