{
  pkgs,
  ...
}:
{

  # Systemd services
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
      };
    };

    # Necessary to manage applications with systemd in Sway:
    # https://github.com/swaywm/sway/wiki/Systemd-integration
    user.targets.sway-session = {
      description = "sway compositor session";
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      bindsTo = [ "graphical-session.target" ];
      documentation = [ "man:systemd.special(7)" ];
    };
  };

  # Incorrect swaylock password fix:
  # https://wiki.nixos.org/wiki/Sway#Swaylock_cannot_be_unlocked_with_the_correct_password
  security.pam.services.swaylock = {};

}
