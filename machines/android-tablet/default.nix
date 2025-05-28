{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.packages = with pkgs; [
    vim
    syncthing
    zip
    unzip
    xz
  ];

  environment.etcBackupExtension = ".bak";

  system.stateVersion = "23.11";

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

}
