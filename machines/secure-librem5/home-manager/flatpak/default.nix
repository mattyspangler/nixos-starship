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
        },
        {
          name = "flathub";
          location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        }
      ];

      packages = [
        # Web Browsing
        #"org.mozilla.firefox"
        { appId = "org.mozilla.firefox"; origin = "PureOS";  }
        #"net.mullvad.MullvadBrowser"
        #"org.torproject.torbrowser-launcher"
        # Communication
        "org.briarproject.Briar"
        "de.schmidhuberj.Flare" # Signal alternative
        #"org.asamk.SignalCli" # For registering signal
        "im.dino.Dino" # XMPP
        "sm.puri.Chatty" # XMPP, SMS, Matrix
        "im.fluffychat.Fluffychat"
        "in.cinny.Cinny" # lightweight matrix client
        "io.github.spacingbat3.webcord"
        "dev.geopjr.Tuba"
        #"ch.protonmail.protonmail-bridge" # cant find on arm
        #"org.mozilla.Thunderbird" # cant find on arm
        # Productivity
        "net.mkiol.SpeechNote"
        "org.gnome.Calendar"
        "org.gnome.Contacts"
        "org.gnome.Evolution" # Needed by Contacts
        "org.gnome.Evince"
        #"org.onlyoffice.desktopeditors"
        #"org.libreoffice.LibreOffice"
        # Media
        "io.freetubeapp.FreeTube"
        "org.gnome.Podcasts"
        "org.gnome.Lollypop"
        "org.gnome.Music"
        "org.gpodder.gpodder-adaptive"
        "io.github.seadve.Mousai"
        "com.github.geigi.cozy"
        "org.gnome.Shotwell"
        #"org.videolan.VLC"
        # Games
        #"com.valvesoftware.Steam"
        # Development
        #"com.vscodium.codium"
        # Security
        #"org.keepassxc.KeePassXC"
        "com.protonvpn.www"
        "com.github.tchx84.Flatseal"
        # Utility
        "xyz.slothlife.Jogger" # fitness app
        "app.organicmaps.desktop"
        "io.github.rinigus.PureMaps"
        "io.github.rinigus.OSMScoutServer"
        "org.gnome.Weather"
        "org.gnome.clocks"
        #"com.calibre_ebook.calibre"
        "com.github.johnfactotum.Foliate" # ebook reader
        "org.gabmus.gfeeds" # rss reader
        "com.belmoussaoui.Authenticator"
        "me.kozec.syncthingtk"
        # Virtualization
        #"io.podman_desktop.PodmanDesktop"
        #"org.gnome.Boxes"
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
