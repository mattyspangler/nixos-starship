{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
  rpi-utils = pkgs.callPackage ../raspberry-pi/packages/rpi-utils {};
  uconsole-4g-cm4 = pkgs.writeShellScriptBin "uconsole-4g-cm4" ''
    function tip {
      echo "use mmcli -L to see 4G modem or not"
    }

    function enable4g {
      echo "Power on 4G module on uConsole cm4"
      ${rpi-utils}/bin/pinctrl set 24 op dh
      ${rpi-utils}/bin/pinctrl set 15 op dh
      ${pkgs.coreutils}/bin/sleep 5
      ${rpi-utils}/bin/pinctrl set 15 dl
      echo "waiting..."
      ${pkgs.coreutils}/bin/sleep 13
      echo "done"
    }

    function disable4g {
      echo "Power off 4G module"
      ${rpi-utils}/bin/pinctrl set 24 op dl
      ${rpi-utils}/bin/pinctrl set 24 dh
      ${pkgs.coreutils}/bin/sleep 3
      ${rpi-utils}/bin/pinctrl set 24 dl
      ${pkgs.coreutils}/bin/sleep 20
      echo "Done"
    }

    if [ "$#" -ne 1 ] ; then
      echo "$0: enable/disable"
      exit 3
    fi

    if [ $1 == "enable" ]; then
      enable4g;
      tip;
    fi

    if [ $1 == "disable" ]; then
      disable4g
      tip;
    fi
  '';
in {
  config = {
    environment.systemPackages = [
      rpi-utils
      uconsole-4g-cm4
      # pkgs.modemmanager
    ];
  };
}
