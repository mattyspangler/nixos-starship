source $HOME/.nix-profile/etc/profile.d/nix.sh
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update && nix-shell '<home-manager>' -A install
#nix profile install github:nix-community/home-manager --extra-experimental-features "nix-command flakes"
home-manager switch --extra-experimental-features 'nix-command flakes' --flake .#user@standalone-dev
