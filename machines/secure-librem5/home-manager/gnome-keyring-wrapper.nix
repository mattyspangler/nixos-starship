{ pkgs }:

let
  # A wrapper for the gnome-keyring-daemon that adds IPC_LOCK capability.
  # This is to work around issues on systems where user sessions
  # don't get this capability by default, leading to errors like:
  # "insufficient process capabilities, insecure memory might get used"
  gnome-keyring-daemon-with-caps = pkgs.writeShellScriptBin "gnome-keyring-daemon" ''
    #!${pkgs.runtimeShell}
    exec ${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --foreground "$@"
  '';
in
# Create a new package that is a copy of gnome-keyring but with the wrapped daemon.
# We use symlinkJoin to avoid rebuilding gnome-keyring itself.
pkgs.symlinkJoin {
  name = "gnome-keyring-wrapped";
  paths = [ pkgs.gnome-keyring ];
  postBuild = ''
    rm $out/bin/gnome-keyring-daemon
    ln -s ${gnome-keyring-daemon-with-caps}/bin/gnome-keyring-daemon $out/bin/gnome-keyring-daemon
  '';
}