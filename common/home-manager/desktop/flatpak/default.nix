{ lib, ... }: {

  services = {
    flatpak = {
      uninstallUnmanaged = true;

      # Update flatpaks at system activation 'nixos-rebuild switch'
      update = {
        onActivation = false;
        auto = {
          enable = true;
          onCalendar = "weekly";
        };
      };

      remotes = lib.mkOptionDefault [{
        name = "flathub-beta";
        location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
        }];

      packages = [
        # Web Browsing
        "org.mozilla.firefox"
        "net.mullvad.MullvadBrowser"
        "com.brave.Browser"
        "org.torproject.torbrowser-launcher"
        # Communication
        "org.mozilla.Thunderbird"
        "ch.protonmail.protonmail-bridge"
        "im.riot.Riot"
        "org.briarproject.Briar"
        "io.github.spacingbat3.webcord"
        "org.signal.Signal"
        # Productivity
        "org.onlyoffice.desktopeditors"
        "org.libreoffice.LibreOffice"
        "org.gnome.Shotwell"
        "com.logseq.Logseq"
        "com.zettlr.Zettlr"
        "org.freeplane.App" # menus are broken
        "com.github.phase1geo.minder"
        "net.xmind.XMind"
        # Art
        "fm.reaper.Reaper"
        "org.kde.krita"
        "org.gimp.GIMP"
        "org.openshot.OpenShot"
        "org.blender.Blender"
        "org.godotengine.GodotSharp"
        "dev.gbstudio.gb-studio"
        # Media
        "org.videolan.VLC"
        "org.musicbrainz.Picard"
        "org.strawberrymusicplayer.strawberry"
        "tv.kodi.Kodi"
        "com.valvesoftware.Steam"
        "io.itch.itch"
        "io.mrarm.mcpelauncher"
        "net.lutris.Lutris"
        "com.vysp3r.ProtonPlus"
        "net.davidotek.pupgui2"
        "com.github.mtkennerly.ludusavi"
        "io.github.philipk.boilr"
        "io.itch.nordup.TheGates"
        "com.steamgriddb.steam-rom-manager"
        "com.steamgriddb.SGDBoop"
        "net.retrodeck.retrodeck"
        "com.moonlight_stream.Moonlight"
        "com.usebottles.bottles"
        "com.heroicgameslauncher.hgl"
        "com.obsproject.Studio"
        "org.deluge_torrent.deluge"
        "org.nicotine_plus.Nicotine"
        "org.gnome.Snapshot"
        "org.kiwix.desktop"
        # Gaming
        "io.mrarm.mcpelauncher"
        # Development
        #"com.vscodium.codium" # switching to host rather than flatpak, it is hard to develop in a flatpak container
        # Security
        #"org.cryptomator.Cryptomator" # fuse3 is not working!
        "org.keepassxc.KeePassXC"
        "org.gnome.World.Secrets"
        "org.bleachbit.BleachBit"
        "com.protonvpn.www"
        "com.github.tchx84.Flatseal"
        "org.nmap.Zenmap"
        "org.wireshark.Wireshark"
        "com.yubico.yubioath"
        "com.nitrokey.nitrokey-app2"
        "io.trezor.suite"
        # Utility
        "net.mkiol.SpeechNote"
        "org.gnome.Logs"
        "org.squey.Squey"
        "io.gitlab.adhami3310.Impression"
        "org.gnome.Evince"
        "com.calibre_ebook.calibre"
        "io.github.dvlv.boxbuddyrs"
        "me.kozec.syncthingtk"
        "io.github.giantpinkrobots.varia"
        # Virtualization
        "io.podman_desktop.PodmanDesktop"
        "org.gnome.Boxes"
      ];

    }; # end flatpak block

  }; # end services block

}
