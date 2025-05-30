{ config, pkgs, ... }:

{
  # Alacritty configuration
  programs.alacritty = {
    enable = true;
    #settings = {
    #  # Import the custom theme
    #  general.import = [ "${pkgs.path}/share/terminfo" ];
    #};
  };

  # TODO: this line doesn't seem to do anything. Delete, revise?
  xdg.configFile."alacritty/alacritty.toml".source = ./config.toml;

  # Ensure Alacritty is installed
  home.packages = with pkgs; [ alacritty ];
}
