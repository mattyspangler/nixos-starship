{ config, lib, pkgs, ... }:

let
  aliases = import ../aliases.nix;
in {
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = aliases;
  };
}