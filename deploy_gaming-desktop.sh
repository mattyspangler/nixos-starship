# Tips for NixOS config management:
# https://nixos-and-flakes.thiscute.world/nixos-with-flakes/other-useful-tips#managing-the-configuration-with-git

# backup old config
sudo mv /etc/nixos /etc/nixos.bak

# move current config to /etc/nixos
sudo cp -r ~/nix-config /etc/nixos

# switch to latest config
sudo nixos-rebuild switch --flake ~/nix-config/#gaming-desktop

# Delete all historical versions older than 7 days
sudo nix profile wipe-history --older-than 7d --profile /nix/var/nix/profiles/system

# Run garbage collection after wiping history
sudo nix-collect-garbage --delete-old
