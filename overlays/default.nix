{ inputs }:

{
  # Add overlays your own flake exports (from overlays and pkgs dir):
  overlays = final: prev: {
    weechat = import ./weechat.nix final prev;
  };
}