{
  config,
  pkgs,
  ...
}:
{

  # udev rules for various controllers:
  # https://gitlab.com/fabiscafe/game-devices-udev

  services.udev.extraRules =   builtins.readFile ./8bitdo.rules
                             + builtins.readFile ./sony.rules
                             + builtins.readFile ./microsoft.rules
                             + builtins.readFile ./nintendo.rules;

}
