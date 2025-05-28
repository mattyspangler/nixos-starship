{
  config,
  pkgs,
  ...
}: let
  deskpi-tools = pkgs.callPackage ../raspberry-pi/packages/deskpi-tools {};
  cfg = config.hardware.deskpi;
in {
  systemd.packages = [deskpi-tools];

  systemd.services."deskpi-safe-shut" = {
    description = "DeskPi Safe-Shutdown Service";
    after = ["shutdown.target"];
    before = ["final.target"];
    wantedBy = ["shutdown.target"];
    conflicts = ["reboot.target"];
    unitConfig = {
      ConditionPathExists = cfg.device;
      DefaultDependencies = "no";
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${deskpi-tools}/bin/safeCutOffPower";
      RemainAfterExit = "yes";
      TimeoutSec = "infinity";
      StandardOutput = "tty";
    };
  };

  systemd.services."deskpi" = {
    description = "DeskPi PWM Control Fan Service";
    after = ["multi-user.target"];
    wantedBy = ["multi-user.target"];
    unitConfig = {
      ConditionPathExists = cfg.device;
    };
    serviceConfig = {
      Type = "simple";
      ExecStart = "${deskpi-tools}/bin/pwmFanControl";
      RemainAfterExit = "no";
    };
  };
}
