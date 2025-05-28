{
  lib,
  pkgs,
  config,
  ...
}: {

  # All packages relevant to my Sway environment:
  home.packages = with pkgs; [
    sway
    wayland
    wofi # launcher
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

  xdg.enable = true;
  xdg.configFile."sway/config" = {
    source = pkgs.substituteAll {
      name = "sway-config";
      src = ./sway-config;
    };
  };

  home.file.".config/sway/50-systemd-user.conf".source = ./50-systemd-user.conf; 
  home.file.".config/waybar/config".source = ./waybar-config;
  home.file.".config/waybar/style.css".source = ./waybar-style.css;
  home.file.".config/wofi/config".source = ./wofi-config;
  home.file.".config/sway/wofi-multimode.sh".source = ./wofi-multimode.sh;

  gtk.enable = true;

}
