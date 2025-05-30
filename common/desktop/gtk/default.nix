{ config, pkgs, ... }:

{
  environment.etc = {
    "gtk-2.0" = {
      source = ./gtk-2.0;
      target = "gtk-2.0";
    };
    "gtk-3.0" = {
      source = ./gtk-3.0;
      target = "gtk-3.0";
    };
    "gtk-3.20" = {
      source = ./gtk-3.20;
      target = "gtk-3.20";
    };
  };

  #environment.systemPackages = [ pkgs.gtk + pkgs.gtk3 + pkgs.gtk4 ];
}
