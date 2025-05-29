{ config, pkgs, ... } : {

  programs.bash = {
    shellAliases = {
      pip = "pip3";
    };
  };

}