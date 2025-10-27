{ config, pkgs, ... }:

{
  # This Nix configuration places your alarm script and sound file
  # into the correct location in your home directory.
  home.file = {
    ".config/my-alarms/at-8am.sh" = {
      source = ./at-8am.sh;
      #executable = true;
    };

    ".config/my-alarms/no-way.flac" = {
      # Assuming 'no-way.flac' is in the same directory as this nix file.
      source = ./no-way.flac;
    };
  };
}