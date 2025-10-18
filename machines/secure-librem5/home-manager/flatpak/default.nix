{ lib, pkgs, ... }: {

  # bubblewrap fails on postmarketos with sxmo-de-sway due to ambient capabilities
  # https://gitlab.postmarketos.org/postmarketOS/pmaports/-/issues/3868
  # https://github.com/containers/bubblewrap/issues/380
  # https://gitlab.gnome.org/World/Phosh/phosh/-/merge_requests/1351
  # Create a wrapper around flatpak to drop ambient capabilities.
  home.packages = [
    (pkgs.writeShellScriptBin "flatpak" ''
      #!${pkgs.runtimeShell}
      exec ${pkgs.util-linux}/bin/setpriv --ambient-caps '-all' ${pkgs.flatpak}/bin/flatpak "$@"
    '')
  ];

  services = {
    flatpak = {
      enable = true;
      uninstallUnmanaged = true;
      update = {
        # with my flatpak dir on sdcard, this was causing massive redownload to ~/.local/share/flatpak, 
        # likely because env vars weren't getting set up early enough in home manager rebuilds
        
        onActivation = false; 
        auto = {
          enable = true;
          onCalendar = "weekly";
        };
      };

      remotes = [
        {
          name = "PureOS";
          location = "https://store.puri.sm/repo/stable/pureos.flatpakrepo";
        }
        {
          name = "flathub";
          location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        }
      ];

      packages = [
        "app.organicmaps.desktop"
        "com.belmoussaoui.Authenticator"
        "com.github.geigi.cozy"
        "com.github.johnfactotum.Foliate"
        "com.github.tchx84.Flatseal"
        "com.protonvpn.www"
        #"ch.protonmail.protonmail-bridge" # cant find on arm
        "de.schmidhuberj.Flare" # Signal alternative
        "de.schmidhuberj.tubefeeder" # Youtube client
        "dev.geopjr.Tuba"
        "im.dino.Dino" # XMPP
        "im.fluffychat.Fluffychat" # Matrix client, does calls but is slow
        #"in.cinny.Cinny" # lightweight matrix client
        "im.nheko.Nheko" # Rust matrix client with calls
        "im.pidgin.Pidgin"
        "io.github.rinigus.OSMScoutServer"
        "io.github.rinigus.PureMaps"
        "io.github.seadve.Mousai"
        #"io.freetubeapp.FreeTube"
        "io.github.spacingbat3.webcord"
        #"io.podman_desktop.PodmanDesktop"
        "me.kozec.syncthingtk"
        "net.mkiol.SpeechNote"
        #"net.mullvad.MullvadBrowser"
        "org.briarproject.Briar"
        "org.gabmus.gfeeds" # rss reader
        "org.gnome.Calendar"
        #"org.gnome.Calls"
        #"org.gnome.Contacts"
        "org.gnome.Evince"
        #"org.gnome.Evolution" # Needed by Contacts
        "org.gnome.Lollypop" # Play and organize music
        "org.gnome.Music"
        "org.gnome.Podcasts"
        "org.gnome.Shotwell"
        "org.gnome.Weather"
        "org.gnome.clocks"
        "org.gpodder.gpodder-adaptive"
        "org.meshtastic.meshtasticd"
        "org.mozilla.firefox"
        #"org.mozilla.Thunderbird" # cant find on arm
        #"org.onlyoffice.desktopeditors"
        "sm.puri.Chatty" # XMPP, SMS, Matrix
        #"org.torproject.torbrowser-launcher"
        "xyz.slothlife.Jogger" # fitness app
        #{ appId = "org.mozilla.firefox"; origin = "PureOS";  }
        #"com.calibre_ebook.calibre"
        #"com.valvesoftware.Steam"
        #"com.vscodium.codium"
        #"org.gnome.Boxes"
        #"org.keepassxc.KeePassXC"
        #"org.libreoffice.LibreOffice"
        #"org.videolan.VLC"
      ];

      overrides = {
        "*" = {
          Context = {
            env = [
              "GTK_THEME=Adwaita:dark"
            ];
          };
        };
        "dev.geopjr.Tuba" = {
          Context = {
            sockets = [ "wayland" "fallback-x11" ];
            talks = [ "org.freedesktop.portal.OpenURI" ];
          };
        };
      };

    }; # end services block

  }; # end flatpak block

}
