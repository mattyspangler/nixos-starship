{
  pkgs,
  ...
}:
{
  services = {
    syncthing = {
      enable = true;
      user = "nix-on-droid";
      configDir = "/data/data/com.termux.nix/files/home/.config/syncthing";
    };
  };
}
