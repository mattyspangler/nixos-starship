nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update && nix-shell '<home-manager>' -A install
#nix profile install github:nix-community/home-manager --extra-experimental-features "nix-command flakes"
# Clean up home-manager generations older than 3 entries
home-manager generations | tail -n +4 | grep -o 'generation [0-9]\+' | cut -d' ' -f2 | xargs -r -- home-manager remove-generations
home-manager switch --extra-experimental-features 'nix-command flakes' --flake .#nebula@libremfive
