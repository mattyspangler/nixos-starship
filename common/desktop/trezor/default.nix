{
  config,
  pkgs,
  ...
}:
{

  services.udev.extraRules =   builtins.readFile ./51-trezor.rules;

}
