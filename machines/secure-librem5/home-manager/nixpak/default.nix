{ config, lib, pkgs, nixpkgs-unstable ? null, ... }:
let
  pkgs-unstable = if nixpkgs-unstable != null then
    import nixpkgs-unstable {
      system = pkgs.system;
      config = pkgs.config;
    }
  else
    pkgs; # fallback to stable if unstable not provided

  mkNixPak = config.lib.nixpak.mkNixPak;

  # Common sandbox configuration for messaging apps
  messagingSandboxBase = {
    dbus.enable = true;
    dbus.policies = {
      "org.freedesktop.DBus" = "talk";
      "ca.desrt.dconf" = "talk";
      "org.freedesktop.Notifications" = "talk";
      "org.freedesktop.portal.Desktop" = "talk";
    };

    flatpak.enable = true;

    bubblewrap = {
      network = true; # Allow network access for messaging
      bind.rw = [
        (sloth.concat' sloth.homeDir "/.config")
        (sloth.concat' sloth.homeDir "/.cache")
        (sloth.env "XDG_RUNTIME_DIR")
        (sloth.concat' sloth.homeDir "/.local/share")
      ];
      bind.ro = [
        "/etc"
        "/run"
        sloth.homeDir
      ];
    };
  };

in
{
  # iamb - Matrix client sandbox
  iamb-nixpak = mkNixPak {
    config = { sloth, ... }: messagingSandboxBase // {
      app.package = pkgs.iamb;
      app.binPath = "bin/iamb";

      flatpak.appId = "com.nixpak.iamb";

      bubblewrap = messagingSandboxBase.bubblewrap // {
        # Additional iamb-specific bindings
        bind.rw = messagingSandboxBase.bubblewrap.bind.rw ++ [
          (sloth.concat' sloth.homeDir "/.local/state/iamb")
        ];
      };
    };
  };

  # gurk-rs - Signal client sandbox
  gurk-rs-nixpak = mkNixPak {
    config = { sloth, ... }: messagingSandboxBase // {
      app.package = pkgs.gurk-rs;
      app.binPath = "bin/gurk";

      flatpak.appId = "com.nixpak.gurk-rs";

      bubblewrap = messagingSandboxBase.bubblewrap // {
        # Additional gurk-rs-specific bindings
        bind.rw = messagingSandboxBase.bubblewrap.bind.rw ++ [
          (sloth.concat' sloth.homeDir "/.local/state/gurk-rs")
        ];
      };
    };
  };

  # Optional: Combined messaging sandbox with both clients
  messaging-sandbox = pkgs.symlinkJoin {
    name = "messaging-sandbox";
    paths = [
      iamb-nixpak.config.env
      gurk-rs-nixpak.config.env
    ];
  };
}