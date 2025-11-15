{
  ll = "ls -la";
  pip = "pip3";
  nrs-gaming-desktop = "sudo nixos-rebuild switch --flake ~/nixos-starship/#gaming-desktop --option binary-caches-parallel-connections 5";
  hms-librem = "~/nixos-starship/deploy_librem5_standalone.sh";
  der = "~/.config/emacs/bin/doom build && ~/.config/emacs/bin/doom sync";
  des = "~/.config/emacs/bin/doom sync";
}