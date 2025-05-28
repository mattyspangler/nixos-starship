{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Sway settings specific to my gaming-desktop:
  wayland.windowManager.sway = {
    #enable = true;
    extraConfig = ''
      output * resolution 3440x1440@160hz
    ''; # Specifying resolution manually, auto-detect takes too long!
  };
}
