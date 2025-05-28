{
  pkgs,
  ...
}:
{

  environment.systemPackages = with pkgs; [
    pam_u2f
    pcscliteWithPolkit
  ];

  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Create u2f_keys file in <repo>/secrets/ and it will be copied to ~/.config/Yubico/u2f_keys
  # Follow guide here: https://nixos.wiki/wiki/Yubikey
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

}
