# Installing NixOS on Pinephone: https://mobile.nixos.org/getting-started.html
# Configuring NixOS on Pinephone: https://wiki.nixos.org/wiki/PinePhone
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{

  imports = [
    ./hardware-configuration.nix
    ./phosh
    #./networking
  ];

  environment.systemPackages = with pkgs; [
    # file tracking
    git
    syncthing
    # terminal
    htop
    tmux
    zsh
    # graphical environment
    brightnessctl
    onboard
    megapixels # best camera app as of 2024
    portfolio-filemanager
    squeekboard
    feh
    # user apps specific to my pinephone
    firefox-wayland # works but doesn't scale down UI well, Gnome WEB is default browser
    # phone stuff
    calls
    chatty #SMS
  ];

  ## Services

  # GPS
  services.geoclue2.enable = true;
  users.users.geoclue.extraGroups = [ "networkmanager" ];

  # Calling
  programs.calls.enable = true;
  # Optional but recommended. https://github.com/NixOS/nixpkgs/pull/162894
  systemd.services.ModemManager.serviceConfig.ExecStart = [
    "" # clear ExecStart from upstream unit file.
    "${pkgs.modemmanager}/sbin/ModemManager --test-quick-suspend-resume"
  ];

}
