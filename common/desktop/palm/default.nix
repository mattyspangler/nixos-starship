{
  config,
  pkgs,
  ...
}:
{

  services.udev.extraRules = builtins.readFile ./99-jpilot.rules;

  environment.systemPackages = with pkgs; [
    jpilot
    pilot-link
    libusb1
  ];

}
