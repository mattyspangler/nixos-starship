{ config, lib, pkgs, ... }:
{
  imports = [
    ./bash
    ./flatpak
    ./sxmo
    ./alacritty
    ./wofi
  ];

  sops = {
    secrets = {
      # To edit:
      # $ nix-shell -p sops --run "sops secrets/secrets.yaml"
      "peanutbutter_pass" = {
      };
    };
  };

  home = {
    username = "nebula";
    homeDirectory = "/home/nebula";

    file.".profile".source = ./profile;
    file.".local/share/applications/firefox-flatpak-handler.desktop".source = ./firefox-flatpak-handler.desktop;

    # Emacs
    file.".config/doom/config.d/mobile.el".source = ./doom/config.d/mobile.el;

    # flatpak
    file.".local/share/flatpak".source = config.lib.file.mkOutOfStoreSymlink "/run/media/nebula/SDCARD/flatpak";
    file.".var/app".source = config.lib.file.mkOutOfStoreSymlink "/run/media/nebula/SDCARD/flatpak-var-app";
    # waydroid
    file.".local/share/waydroid".source = config.lib.file.mkOutOfStoreSymlink "/run/media/nebula/SDCARD/waydroid";
    #file."/var/lib/waydroid".source = config.lib.file.mkOutOfStoreSymlink "/run/media/nebula/SDCARD/waydroid-system"; # I may need a systemd service for this one
    # user dirs
    file."Documents".source = config.lib.file.mkOutOfStoreSymlink "/run/media/nebula/SDCARD/Documents";
    file."Music".source = config.lib.file.mkOutOfStoreSymlink "/run/media/nebula/SDCARD/Music";
    file."Downloads".source = config.lib.file.mkOutOfStoreSymlink "/run/media/nebula/SDCARD/Downloads";

    stateVersion = "24.05";
    packages = with pkgs; [
      abook # address book, works with calcure and mutt
      alacritty
      baresip
      calls
      calcure # TUI calendar, works with abook and mutt
      clamtk
      dillo
      #espeak # tts engine
      #evolution
      # Evolution does not play well with ambient capabilities, probably related to using bubblewrap:
      # https://discourse.nixos.org/t/evolution-crashes-on-launch/57208
      # https://gitlab.postmarketos.org/postmarketOS/pmaports/-/issues/3868
      # https://github.com/containers/bubblewrap/issues/380
      # https://gitlab.gnome.org/World/Phosh/phosh/-/merge_requests/1351
      #(pkgs.writeShellScriptBin "evolution" ''
      #  #!${pkgs.runtimeShell}
      #  exec ${pkgs.util-linux}/bin/setpriv --ambient-caps '-all' ${pkgs.evolution}/bin/evolution "$@"
      #'')
      #evolution-data-server
      fail2ban
      feather
      geoclue2
      gnome-contacts
      gnupg
      #gnustep-gui
      homebank
      keepassxc
      libsecret
      megapixels # Using pmos package instead, has device specific configs
      nerd-fonts.droid-sans-mono
      nerd-fonts.fira-code
      nerd-fonts.hack
      #octave # calculator and matlab clone, cli and gui
      opensnitch
      pcscliteWithPolkit # needed for nitrokey and keepassxc
      #pidgin opting for flatpak
      pinentry-all
      podman
      protonmail-bridge
      #speechd # spd-say TTS tool
      swaylock
      #tartube # youtube cli client that works with yt-dlp
      #waydroid # I need to use the postmarketos package to get the systemd additions
      #ufw #not available?
      #chrootkit #not available?
      #rkhunter #not available?
    ];

  }; # end home block

  programs.zsh.enable = true;

  programs.keepassxc = {
    enable = true;
    #autostart = true;
  };

  # Required to install flatpak
  xdg = {
    enable = true;
    mime.enable = true;
    portal = {
      enable = true;
      config = {
        common = {
          default = [ "termfilechooser" "wlr" "gtk" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
        };
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-termfilechooser
        xdg-desktop-portal-wlr
        #xdg-desktop-portal-kde
        #xdg-desktop-portal-gtk
      ];
    }; # end portal block

    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "firefox-flatpak-handler.desktop";
        "x-scheme-handler/http" = "firefox-flatpak-handler.desktop";
        "x-scheme-handler/https" = "firefox-flatpak-handler.desktop";
        "x-scheme-handler/about" = "firefox-flatpak-handler.desktop";
      };
    };
  };

  # home.file.".local/bin/update_librem5" = {
  #   source = (config.home.homeDirectory + "/nixos-starship/update_librem5.sh");
  #   executable = true;
  # };

  # home.file.".local/bin/deploy_librem5_standalone" = {
  #   source = (config.home.homeDirectory + "/nixos-starship/deploy_librem5_standalone.sh");
  #   executable = true;
  # };

  services.podman = {
    enable = true;
  };

  #services.pass-secret-service.enable = true;
  #services.gnome-keyring.enable = true;

  #services.gnome.evolution-data-server.enable = true;
  #programs.dconf.enable = true;

  #services.pcscd = {
  #  enable = true;
  #};

  programs.nixpak = {
    enable = true;
    apps = [
      "iamb"
      "profanity"
      "gurk-rs"
      "lynx"
      "weechat"
      "toot"
      "tuisky"
    ];
    enableWrapper = true;
    debug = false;
  };

}
