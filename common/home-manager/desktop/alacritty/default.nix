{ config, pkgs, ... }:

{
  xdg.configFile."alacritty/config.toml".source = ./config.toml;
}