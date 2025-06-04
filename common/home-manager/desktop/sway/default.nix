{
  lib,
  pkgs,
  config,
  ...
}: {

  home = {
    # All packages relevant to my Sway environment:
    packages = with pkgs; [
      sway
      wayland
      wofi # launcher
      wofi-emoji
      cheat
      navi
      #notify-osd
      libnotify
      #dunst # notify daemon
      xdg-utils
      glib
      brightnessctl
      pavucontrol
      alacritty
      playerctl
      xfce.thunar # file manager
      lxappearance # theme settings
      wl-clipboard # clipboard manager
      yad # gui dialogs for shell scripts
      ydotool # generic command-line automation for wayland
      wtype # xdotool type automation for wayland
      espanso-wayland # text expander for wayland
      swww # wallpaper changer
      grim # screenshots
      waybar
      wdisplays # gui for configuring displays
      wmctrl # needed to activate app focus for ulauncher
      mako # notification manager
      slurp # dimension-grabbing CLI, to use with grim
      swayidle # idle manager
      swaylock # screen lock
      papirus-icon-theme # icon theme
    ];

    file = {
      # sway
      ".config/sway/50-systemd-user.conf".source = ./50-systemd-user.conf;

      # waybar
      ".config/waybar/config".source = ./waybar-config;
      ".config/waybar/style.css".source = ./waybar-style.css;

      # wofi configs
      ".config/wofi/config".source = ./wofi/wofi-config;
      ".config/wofi/style.css".source = ./wofi/wofi-style.css;
      ".ai-wofi-settings".source = ./wofi/ai-wofi-settings;

      # wofi scripts
      ".config/wofi/hacky-wofi" = {
        source = ./wofi/hacky-wofi;
        executable = true;
      };
      ".config/wofi/ai-wofi.py" = {
        source = ./wofi/ai-wofi.py;
        executable = true;
      };
      ".config/wofi/cheat-wofi" = {
        source = ./wofi/cheat-wofi;
        executable = true;
      };

      # wallpaper
      "nixship-wallpaper.png".source = ./wallpapers/nixship-wallpaper.png;
    };

  }; # end home block

  xdg.enable = true;
  xdg.configFile."sway/config" = {
    source = pkgs.substituteAll {
      name = "sway-config";
      src = ./sway-config;
    };
  };

  gtk.enable = true;
}
