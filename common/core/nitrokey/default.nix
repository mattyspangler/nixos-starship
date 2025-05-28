{ pkgs, ... }: {
  services.udev.packages = [
    pkgs.nitrokey-udev-rules  # Contains rules for all Nitrokey devices
  ];
}