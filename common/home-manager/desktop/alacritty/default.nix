{ config, pkgs, ... }:

{
  # Alacritty configuration
  programs.alacritty = {
    enable = true;
    settings = {
      # Import the custom theme
      import = [ "${pkgs.path}/share/terminfo" ];
    };
  };

  xdg.configFile."alacritty/config.toml".source = ./config.toml;

  # Ensure Alacritty is installed
  home.packages = with pkgs; [ alacritty ];
}
