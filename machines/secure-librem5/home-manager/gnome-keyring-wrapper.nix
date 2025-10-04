{ pkgs, ... }:

let
  gnome-keyring-daemon-wrapped = pkgs.writeShellScriptBin "gnome-keyring-daemon" ''
    #!${pkgs.runtimeShell}
    exec ${pkgs.util-linux}/bin/setpriv --ambient-caps '-all' ${pkgs.gnome-keyring}/bin/gnome-keyring-daemon "$@"
  '';
in
{
  # This wrapper for the daemon should be picked up by the gnome-keyring service.
  # It will be placed in ~/.nix-profile/bin which is in the PATH.
  home.packages = [ gnome-keyring-daemon-wrapped ];

  # Also, increase the memlock limit so the daemon doesn't need CAP_IPC_LOCK.
  # This should address the "insecure memory might get used" warning.
  systemd.user.services.gnome-keyring = {
    # The service is defined by the services.gnome-keyring module.
    # We are just overriding some settings here.
    serviceConfig = {
      LimitMEMLOCK = "infinity";
    };
  };
}