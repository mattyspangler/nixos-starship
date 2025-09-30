{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{

  imports = [
    ./flatpak
    ./zsh
    ./nitrokey
  ];

  sops = {
    age.keyFile = "/var/lib/sops/keys.txt";
    # TODO: relative path
    defaultSopsFile = "/home/nebula/nixos-starship/secrets/secrets.yaml";
    defaultSopsFormat = "yaml";
    validateSopsFiles = false;
    # TODO: need to use mkDefault/mkOverride for systems that aren't nebula
    secrets = {
      # To edit:
      # $ nix-shell -p sops --run "sops secrets/secrets.yaml"
      "nano-gpt_key" = {
        neededForUsers = true;
      };
    };
  };

  programs.gnupg.agent = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    gnupg
    coreutils
    syncthing
    tmux
    zellij
    tldr
    clamav
    aide
    wget
    vim
    firewalld
    (sops.withAgePlugins (p: [
      p.age-plugin-fido2-hmac
      #p.age-plugin-yubikey
      #p.age-plugin-tpm
      #p.age-plugin-ledger
    ]))
    libfido2
    age-plugin-fido2-hmac
  ];

  # Required by flatpak:
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      #xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
    config = {
      common  = {
        default = [
          "gtk"
          #"plasma"
        ];
      };
    };
  };

  # Reducing disk usage
  # https://nixos-and-flakes.thiscute.world/nixos-with-flakes/other-useful-tips#managing-the-configuration-with-git
  # Perform garbage collection weekly to maintain low disk usage
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-old --keep 15";
    };
  };

  # Optimize storage
  # You can also manually optimize the store via:
  #    nix-store --optimise
  # Refer to the following link for more details:
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;

    # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

}
