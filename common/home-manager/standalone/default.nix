{
  config,
  pkgs,
  ...
}: {

  imports = [
    ./bash
    #./zsh
    #./flatpak
  ];

  home.username = "user";
  home.homeDirectory = "/home/user";

  # This defines the packages you want to install for the user
  home.packages = with pkgs; [
    syncthing       # Syncing tool
    impression      # create bootable drives
    # Emacs dependencies:
    libtool
    cmake
    zstd
  ];

  # Optional: Configure additional user environment settings
  home.stateVersion = "24.11";  # Adjust the Home Manager version

}
