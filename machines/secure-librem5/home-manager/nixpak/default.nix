{ pkgs, lib, nixpak, ... }:

let
  mkNixPak = nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  profanity-sandboxed = mkNixPak {
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
            (sloth.mkdir (sloth.concat' sloth.homeDir "/.local/state/nixpak/profanity/local/share"))
            (sloth.concat' sloth.homeDir "/.local/share")
          ]
          (sloth.env "XDG_RUNTIME_DIR")
        ];
        bind.ro = [
          (sloth.concat' sloth.homeDir "/Downloads")
        ];
      };
    };
  };

  iamb-sandboxed = mkNixPak {
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
          [
            (sloth.mkdir (sloth.concat' sloth.homeDir "/.local/state/nixpak/iamb/config"))
            (sloth.concat' sloth.homeDir "/.config")
          ]
          [
            (sloth.mkdir (sloth.concat' sloth.homeDir "/.local/state/nixpak/iamb/local/share"))
            (sloth.concat' sloth.homeDir "/.local/share")
          ]
          (sloth.env "XDG_RUNTIME_DIR")
        ];
        bind.ro = [
          (sloth.concat' sloth.homeDir "/Downloads")
        ];
      };
    };
  };

in
{
  home.packages = [
    profanity-sandboxed.config.script
    iamb-sandboxed.config.script
  ];
}