{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{

  # Sensors
  hardware.sensor.iio.enable = true;
  hardware.firmware = [ config.mobile.device.firmware ];

  # Bluetooth
  mobile.boot.stage-1.firmware = [
    config.mobile.device.firmware
  ];

  # Modem firmware
  services.fwupd.enable = true;

}
