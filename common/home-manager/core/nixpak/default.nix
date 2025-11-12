{ config, lib, pkgs, nixpak, ... }:

with lib;

let
  cfg = config.programs.nixpak;

  mkNixPak = nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
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
        };
        flatpak.appId = "de.snikker.iamb";
        bubblewrap = {
          bind.rw = [
            (sloth.concat' sloth.homeDir "/.config/iamb")
            # Mount a persistent data directory
            [
              (sloth.mkdir (sloth.concat' sloth.homeDir "/.local/state/nixpak/iamb/share"))
              (sloth.concat' sloth.homeDir "/.local/share/iamb")
            ]
            (sloth.env "XDG_RUNTIME_DIR")
          ];
          bind.ro = [
            (sloth.concat' sloth.homeDir "/Downloads")
          ];
        };
      };
    };

    profanity = mkNixPak {
      config = { sloth, ... }: {
        app.package = pkgs.profanity;
        dbus.enable = true;
        dbus.policies = {
          "org.freedesktop.portal.Desktop" = "talk";
          "org.freedesktop.Notifications" = "talk";
        };
        flatpak.appId = "im.profanity.Profanity";
        bubblewrap = {
          bind.rw = [
            [
              (sloth.mkdir (sloth.concat' sloth.homeDir "/.local/state/nixpak/profanity/config"))
              (sloth.concat' sloth.homeDir "/.config")
            ]
            [
              (sloth.mkdir (sloth.concat' sloth.homeDir "/.local/state/nixpak/profanity/share"))
              (sloth.concat' sloth.homeDir "/.local/share/profanity")
            ]
            (sloth.env "XDG_RUNTIME_DIR")
          ];
          bind.ro = [
            (sloth.concat' sloth.homeDir "/Downloads")
          ];
        };
      };
    };

    "gurk-rs" = mkNixPak {
      config = { sloth, ... }: {
        app.package = pkgs.gurk-rs;
        bubblewrap = {
          bind.rw = [
            [
              (sloth.mkdir (sloth.concat' sloth.homeDir "/.local/state/nixpak/gurk-rs/config"))
              (sloth.concat' sloth.homeDir "/.config")
            ]
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
            [
              (sloth.mkdir (sloth.concat' sloth.homeDir "/.local/state/nixpak/weechat/config"))
              (sloth.concat' sloth.homeDir "/.weechat")
            ]
            (sloth.env "XDG_RUNTIME_DIR")
          ];
        };
      };
    };

    toot = mkNixPak {
      config = { sloth, ... }: {
        app.package = pkgs.toot;
        bubblewrap = {
          bind.rw = [
            [
              (sloth.mkdir (sloth.concat' sloth.homeDir "/.local/state/nixpak/toot/config"))
              (sloth.concat' sloth.homeDir "/.config")
            ]
          ];
        };
      };
    };

    tuisky = mkNixPak {
      config = { sloth, ... }: {
        app.package = pkgs.tuisky;
        bubblewrap = {
          bind.rw = [
            [
              (sloth.mkdir (sloth.concat' sloth.homeDir "/.local/state/nixpak/tuisky/config"))
              (sloth.concat' sloth.homeDir "/.config")
            ]
          ];
        };
      };
    };
  };

  # Function to create a wrapper for an app
  mkWrapper = appName: appPkg:
    pkgs.writeShellScriptBin appName ''
      #!${pkgs.runtimeShell}
      exec ${pkgs.util-linux}/bin/setpriv --ambient-caps '-all' ${appPkg}/bin/${appName} "$@"
    '';

  # Get the list of packages to install based on the config
  packagesToInstall =
    let
      selectedApps = builtins.filter (app: builtins.elem app cfg.apps) (builtins.attrNames sandboxed-apps);
      getPkg = appName: (sandboxed-apps.${appName}).config.script;
    in
    if cfg.enableWrapper then
      map (appName: mkWrapper appName (getPkg appName)) selectedApps
    else
      map (appName: getPkg appName) selectedApps;

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
  };

  config = mkIf cfg.enable {
    home.packages = packagesToInstall;
  };
}