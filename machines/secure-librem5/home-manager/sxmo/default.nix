{
  pkgs,
  ...
}:
{

   home = {
  #   # All packages relevant to my Sway environment:
  #   packages = with pkgs; [
  #     sway
  #     wayland
  #     wofi # launcher
  #     wofi-emoji
  #     cheat
  #     navi
  #     bc
  #     numbat
  #     #notify-osd
  #     libnotify
  #     libinput
  #     #dunst # notify daemon
  #     xdg-utils
  #     glib
  #     brightnessctl
  #     pavucontrol
  #     alacritty
  #     playerctl
  #     xfce.thunar # file manager
  #     lxappearance # theme settings
  #     wl-clipboard # clipboard manager
  #     yad # gui dialogs for shell scripts
  #     ydotool # generic command-line automation for wayland
  #     wtype # xdotool type automation for wayland
  #     espanso-wayland # text expander for wayland
  #     swww # wallpaper changer
  #     grim # screenshots
  #     waybar
  #     wdisplays # gui for configuring displays
  #     wmctrl # needed to activate app focus for ulauncher
  #     mako # notification manager
  #     slurp # dimension-grabbing CLI, to use with grim
  #     swayidle # idle manager
  #     swaylock # screen lock
  #     papirus-icon-theme # icon theme
  #   ];

    file = {
      # For adding applications to the swipe down menu
      # https://wiki.postmarketos.org/wiki/Sxmo/Tips_and_Tricks
      ".config/sxmo/hooks/sxmo_hook_apps.sh".source = ./hooks/sxmo_hook_apps.sh;

      ".config/sxmo/bonsai_tree.json".source = ./bonsai_tree.json;
      ".config/conky/conky.conf".source = ./conky.conf;
      ".config/sxmo/profile".source = ./profile;
    };

  }; # end home block

  xdg.configFile."sway/config".source = ./sway;
}
