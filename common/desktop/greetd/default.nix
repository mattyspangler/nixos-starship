{ config, lib, pkgs, ... }:
let
  swayConfig = pkgs.writeText "greetd-sway-config" ''
    # gtkgreet takes 15-30 seconds to start
    # https://github.com/swaywm/sway/wiki#gtk-applications-take-20-seconds-to-start
    exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK
    exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l --style /etc/greetd/greetd.css; swaymsg exit"
    bindsym Mod4+shift+e exec swaynag \
      -t warning \
      -m 'What do you want to do?' \
      -b 'Poweroff' 'systemctl poweroff' \
      -b 'Reboot' 'systemctl reboot'
  '';
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.sway}/bin/sway --config ${swayConfig}";
      };
    };
  };

  environment.etc."greetd/environments".text = ''
    sway
    zsh
    labwc
  '';

  environment.etc."greetd/greetd.css".source = ./greetd-style.css;
}
