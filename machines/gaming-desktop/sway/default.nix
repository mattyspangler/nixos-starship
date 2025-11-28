{
  pkgs,
  ...
}:
{
  # Gaming desktop specific swayfx settings
  home.file.".config/sway/config.d/20-gaming.conf".text = ''
    output * resolution 3440x1440@160hz
    # SwayFX gaming optimizations
    shadows disable  # Disable shadows for gaming performance
    layer_effects "waybar" disable
    for_window [class=".*"] opacity set 1.0  # Full opacity for gaming
  '';
}
