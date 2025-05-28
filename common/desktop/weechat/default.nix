# Configuration reference:
# - http://ryantm.github.io/nixpkgs/builders/packages/weechat/

{ pkgs,
  ... 
}:
{

  nixpkgs.overlays = [ (import ../../../overlays/weechat.nix) ];

  # Started breaking after 25.x nixos update
  #services.weechat.enable = true;

  environment.systemPackages = with pkgs; [
    weechat
  ];

}
