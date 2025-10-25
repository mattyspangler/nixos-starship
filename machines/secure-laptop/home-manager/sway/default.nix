{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.file = {
    ".config/sway/config.d/10-resolution.conf".source = ./10-resolution.conf;
  };
}