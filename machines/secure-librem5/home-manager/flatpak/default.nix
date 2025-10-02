{ lib, ... }: {

  # bubblewrap fails on postmarketos with sxmo-de-sway due to ambient capabilities
  # https://gitlab.postmarketos.org/postmarketOS/pmaports/-/issues/3868

  services = {
    flatpak = {
      enable = true;
      uninstallUnmanaged = true;
      update = {
        onActivation = true;
        auto = {
          enable = true;
          onCalendar = "weekly";
        };
      };

      #remotes = [{
      #  name = "flathub-beta";
      #  location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
      #}];

      packages = [
        # Web Browsing
        "org.mozilla.firefox"
        "net.mullvad.MullvadBrowser"
        #"org.torproject.torbrowser-launcher"
        # Communication
        #"im.riot.Riot" # looks like Quadrix and nheko are working alternatives!
        #"org.briarproject.Briar"
        #"de.schmidhuberj.Flare" # Signal alternative
        #"sm.puri.Chatty" # XMPP, SMS, Matrix
        # Productivity
        #"org.onlyoffice.desktopeditors"
        #"org.libreoffice.LibreOffice"
        # Media
        #"org.videolan.VLC"
        # Development
        #"com.vscodium.codium"
        # Security
        #"org.keepassxc.KeePassXC"
        #"com.protonvpn.www"
        "com.github.tchx84.Flatseal"
        # Utility
        #"xyz.slothlife.Jogger" # fitness app
        #"com.calibre_ebook.calibre"
        #"com.github.johnfactotum.Foliate" # ebook reader
        #"org.gabmus.gfeeds" # rss reader
        #"com.belmoussaoui.Authenticator"
        #"org.gnome.clocks"
        #"app.organicmaps.desktop"
        "me.kozec.syncthingtk"
        # Virtualization
        #"io.podman_desktop.PodmanDesktop"
        #"org.gnome.Boxes"
      ];

    }; # end services block

  }; # end flatpak block

}
