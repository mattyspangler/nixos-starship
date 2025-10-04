# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, ... }:

{
  imports = [
    ./hardening
    ./greetd
    ./weechat
    ./virtualisation
    ./bitlbee
    ./sway
    ./steam
    ./trezor
    ./palm
    ./ml
    ./waydroid
    ./vscodium
    ./daw
    ./gtk
    ./flipper
    ./hamradio
  ];

  # Bootloader.
  boot = {
    loader = { 
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;

      # Reduce disk usage
      # Limit the number of generations to keep
      systemd-boot.configurationLimit = 15;
      # grub.configurationLimit = 10;
    };

    # So I can compile for other architectures
    binfmt.emulatedSystems = [ "aarch64-linux" ];

  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Group used for connecting my external usb devices:
  users.groups = {
    plugdev = {};
    dialout = {};
    # Group for access to security-related logs:
    seclogs = {};
    ollama = {};
    media-access = {};
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    nebula = {
      isNormalUser = true;
      description = "nebula";
      extraGroups = [
        "networkmanager"
        "wheel"
        "plugdev"
        "dialout"
        "seclogs"
        "ollama"
        "media-access"
      ];
      packages = with pkgs; [];
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable the Flakes feature
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      wget
      git
      unzip
      baobab
      kooha
      wayfarer
      # nixos tools
      deadnix
      statix
      nix-output-monitor
      nix-tree
      alejandra
      nix-fast-build
      # security tools:
      lynis
      firewalld-gui
      pika-backup
      polkit
      polkit_gnome
      gparted  
      gnome-disk-utility
      dpkg # for extracting .deb files
      labwc # openbox-like wayland wm, fallback if sway breaks
      usbutils
      xorg.xrandr
      # silly
      cmatrix
    ];

    variables.EDITOR = "emacs";

  };

  # Fonts
  fonts = {
    enableDefaultPackages = true;
    
    packages = with pkgs; [
      font-awesome
      powerline-fonts
      powerline-symbols
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      nerd-fonts.hack
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.symbols-only
    ];

    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" "Source Han Serif" ];
      sansSerif = [ "Open Sans" "Source Han Sans" ];
      emoji = [ "Noto Color Emoji" ];
    };

    fontDir.enable = true;

  };

  # Necessary to manage swaywm with Home Manager, also necessary for interactive authentication:
  security.polkit.enable = true;

  xdg.mime = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "thunar";
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services = {

    # Bluetooth
    blueman.enable = true;

    # Enable the gnome-keyring secrets vault.
    # Will be exposed through DBus to programs willing to store secrets.
    # gnome.gnome-keyring.enable = true; # commented out because I use keepassxc secret service instead now
    #services.pass-secret-service.enable = true;

    # Automount drives
    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;

    # Enable the OpenSSH daemon.
    # services.openssh.enable = true;

    # Audio services
    
    # Pipewire
    # Remove sound.enable or set it to false if you had it set previously, as sound.enable is only meant for ALSA-based configurations
    # rtkit is optional but recommended
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };

    # MPD
    mpd = {
      enable = true;
      musicDirectory = "/home/nebula/Music";
      
      extraConfig =  ''
        audio_output {
          type "pipewire"
          name "My PipeWire Output"
        }
      '';
      
      # Optional:
      network.listenAddress = "any"; # if you want to allow non-localhost connections
      startWhenNeeded = true; # systemd feature: only start MPD service upon connection to its socket
    };

  }; # end services block

  # recommended for pipewire:
  security.rtkit.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
