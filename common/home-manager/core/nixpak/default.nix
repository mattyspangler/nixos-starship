{ config, lib, pkgs, nixpak, ... }:

with lib;

let
  cfg = config.programs.nixpak;

  # Create a wrapped bubblewrap that drops ambient capabilities
  # This is needed for PostmarketOS/sxmo-de-sway compatibility
  wrappedBubblewrap = pkgs.writeShellScriptBin "bwrap" ''
    #!${pkgs.runtimeShell}
    exec ${pkgs.util-linux}/bin/setpriv --ambient-caps '-all' ${pkgs.bubblewrap}/bin/bwrap "$@"
  '';

  # Override pkgs to use our wrapped bubblewrap if enableWrapper is true
  wrappedPkgs = if cfg.enableWrapper then
    pkgs // { bubblewrap = wrappedBubblewrap; }
  else
    pkgs;

  mkNixPak = nixpak.lib.nixpak {
    inherit (pkgs) lib;
    pkgs = wrappedPkgs;
  };

  # Define all available sandboxed applications
  sandboxed-apps = {
    iamb = mkNixPak {
      config = { sloth, ... }: {
        app.package = pkgs.iamb;
        dbus.enable = true;
        dbus.policies = {
          "org.freedesktop.portal.Desktop" = "talk";
          "org.freedesktop.Notifications" = "talk";
          "org.freedesktop.secrets" = "talk";
        };
        flatpak.appId = "de.snikker.iamb";
        bubblewrap = {
          bind.rw = [
            # Mount the specific config directory directly
            (sloth.concat' sloth.homeDir "/.config/iamb/config.toml")
            (sloth.concat' sloth.homeDir "/.config/sops-nix/secrets/iamb_config")
            (sloth.concat' sloth.homeDir "/.local/share/iamb")
            (sloth.env "XDG_RUNTIME_DIR")
            # I don't think I need these next three?
            "/dev/shm"
            "/dev/tty"
            "/dev/pts"
          ];
          bind.ro = [
            (sloth.concat' sloth.homeDir "/Downloads")
            "/etc/resolv.conf"
            "/etc/ssl/certs"
          ];
        };
      };
    };

    profanity = mkNixPak {
      config = { sloth, ... }: {
        app.package = pkgs.profanity;
        # TODO: needed?
        # buildInputs = with pkgs; [
        #   curl
        #   sqlite
        #   qrencode
        #   libgcrypt
        #   libotr
        #   gpgme
        #   libassuan
        #   libgpg-error
        #   #libXScrnSaver
        #   libstrophe
        #   expat
        #   glib
        #   libnotify
        #   gdk-pixbuf
        #   python3
        #   gtk3
        #   at-spi2-core
        #   cairo
        #   pango
        #   harfbuzz
        #   ncurses
        #   openssl
        #   zlib
        #   readline
        #   libsignal-protocol-c
        # ];
        dbus.enable = true;
        dbus.policies = {
          "org.freedesktop.portal.Desktop" = "talk";
          "org.freedesktop.Notifications" = "talk";
          "org.freedesktop.secrets" = "talk";
        };
        flatpak.appId = "im.profanity.Profanity";
        bubblewrap = {
          # TODO: how do I do this?
          #args = [ "--unshare-pid" ];
          bind.rw = [
            (sloth.concat' sloth.homeDir "/.config/profanity")
            [
              (sloth.mkdir (sloth.concat' sloth.homeDir "/.local/state/nixpak/profanity/share"))
              (sloth.concat' sloth.homeDir "/.local/share/profanity")
            ]
            (sloth.env "XDG_RUNTIME_DIR")
            "/dev/shm"
            "/dev/tty"
            "/dev/pts"
          ];
          bind.ro = [
            (sloth.concat' sloth.homeDir "/.Xauthority")
            (sloth.concat' sloth.homeDir "/.config/gtk-3.0")
            (sloth.concat' sloth.homeDir "/Downloads")
            "/etc/resolv.conf"
            "/etc/ssl/certs"
            "/etc/fonts"
            "/etc/hosts"
            "/proc"
            "/sys"
            "/usr/lib/locale"
            "/usr/share/zoneinfo"
            "/etc/localtime"
            "/dev"
          ];
        };
      };
    };

    "gurk-rs" = mkNixPak {
      config = { sloth, ... }: {
        app.package = pkgs.gurk-rs;
        bubblewrap = {
          bind.rw = [
            (sloth.concat' sloth.homeDir "/.local/state/nixpak/gurk-rs/config")
            [
              (sloth.mkdir (sloth.concat' sloth.homeDir "/.local/state/nixpak/gurk-rs/share"))
              (sloth.concat' sloth.homeDir "/.local/share/gurk")
            ]
          ];
        };
      };
    };

    lynx = mkNixPak {
      config = { sloth, ... }: {
        app.package = pkgs.lynx;
        bubblewrap = {
          # lynx needs access to home for config and downloads
          bind.rw = [ sloth.homeDir ];
        };
      };
    };

    weechat = mkNixPak {
      config = { sloth, ... }: {
        app.package = pkgs.weechat;
        bubblewrap = {
          bind.rw = [
            (sloth.concat' sloth.homeDir "/.weechat")
            (sloth.env "XDG_RUNTIME_DIR")
            "/dev/shm"
          ];
        };
      };
    };

    toot = mkNixPak {
      config = { sloth, ... }: {
        app.package = pkgs.toot;
        bubblewrap = {
          bind.rw = [
            (sloth.concat' sloth.homeDir "/.config/toot")
          ];
        };
      };
    };

    tuisky = mkNixPak {
      config = { sloth, ... }: {
        app.package = pkgs.tuisky;
        bubblewrap = {
          bind.rw = [
            (sloth.concat' sloth.homeDir "/.config/tuisky")
          ];
        };
      };
    };

    "sandbox-shell" = mkNixPak {
      config = { sloth, ... }: {
        app.package = pkgs.bashInteractive;
        bubblewrap = {
          bind.rw = [
            # This gives the shell full access to your home directory.
            # You can change this to a more restrictive path for a tighter sandbox.
            sloth.homeDir
            # The following are often needed for interactive applications.
            (sloth.env "XDG_RUNTIME_DIR")
            "/dev/shm"
            "/dev/tty"
            "/dev/pts"
          ];
          bind.ro = [
            # You could add read-only paths here, e.g. "/etc/resolv.conf" for DNS.
          ];
        };
      };
    };
  };

  # Function to create a debug wrapper for an app
  mkDebugWrapper = appName: appPkg:
    pkgs.writeShellScriptBin appName ''
      #!${pkgs.runtimeShell}
      exec ${pkgs.strace}/bin/strace -f -o /tmp/${appName}-strace.log ${appPkg}/bin/${appName} "$@"
    '';

  # Get the list of packages to install based on the config
  packagesToInstall =
    let
      selectedApps = builtins.filter (app: builtins.elem app cfg.apps) (builtins.attrNames sandboxed-apps);
      getPkg = appName: sandboxed-apps.${appName}.config.script;
    in
    if cfg.debug then
      map (appName: mkDebugWrapper appName (getPkg appName)) selectedApps
    else
      map getPkg selectedApps;

in
{
  options.programs.nixpak = {
    enable = mkEnableOption "Enable sandboxed CLI applications via nixpak";

    apps = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of applications to sandbox.";
      example = [ "iamb" "profanity" ];
    };

    enableWrapper = mkOption {
      type = types.bool;
      default = false;
      description = "Enable setpriv wrapper for environments with ambient capabilities issues (e.g., PostmarketOS).";
    };

    debug = mkOption {
      type = types.bool;
      default = false;
      description = "Enable strace wrapper for debugging.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = packagesToInstall;
  };
}