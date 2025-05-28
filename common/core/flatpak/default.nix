{ 
  config,
  lib, 
  ... 
}: {

  # nix-flatpak setup
  services.flatpak.enable = true;
}
