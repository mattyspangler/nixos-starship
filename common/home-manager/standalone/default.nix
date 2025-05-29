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

  home = {
    username = "user";
    homeDirectory = "/home/user";

  # This defines the packages you want to install for the user
    packages = with pkgs; [
      syncthing       # Syncing tool
      impression      # create bootable drives
      # Emacs dependencies:
      libtool
      cmake
      zstd
    ];

    # Optional: Configure additional user environment settings
    stateVersion = "24.11";  # Adjust the Home Manager version

  }; # end home block

}
