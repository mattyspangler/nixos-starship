{
  config,
  pkgs,
  ...
}:
{
  xserver.desktopManager.phosh = {
    enable = true;
    user = "nebula";
    group = "users";
    # for better compatibility with x11 applications
    phocConfig.xwayland = "immediate";
  };
}
