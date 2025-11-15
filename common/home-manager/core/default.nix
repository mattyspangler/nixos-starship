{
  config,
  pkgs,
  ...
}: {

  imports = [
    ./emacs
    ./ml
    ./zsh
    ./bash
    ./my-alarms
    ./nixpak
  ];

  modules.editors.emacs = {
    enable = true;
  };

  home.packages = with pkgs; [
    zstd
    git
    age
    (sops.withAgePlugins (p: [
      p.age-plugin-fido2-hmac
      #p.age-plugin-yubikey
      #p.age-plugin-tpm
      #p.age-plugin-ledger
    ]))
    libfido2
    age-plugin-fido2-hmac
    pika-backup
    qrencode
    zbar # used for reading png into qrencode
    conky
    
    # CLI Applications
    aide
    aichat
    at
    calcurse
    castero
    clamav
    cmake
    cmus
    elinks # cli browser with javascript
    epy # cli ebook reader
    fzf
    gdb # gnu debugger, used by emigo for emacs
    khal # cli calendar
    khard # cli address book 
    libtool
    lynis
    macchanger
    mat2
    mc # midnight commander
    mpv
    mutt # email program
    navi # cheatsheet program
    newsboat # rss client
    newsraft # lighter rss client
    pass
    peaclock # clock, timer, stopwatch for terminal
    ranger # terminal file manager
    remind
    rsync
    sc-im # cli spreadsheet app
    sqlite # used to read firefox bookmarks
    tty-clock
    viu # cli image viewer
    vim
    vscodium
    wordgrinder # word processor
    wyrd # frontend for remind
    xplr # polished, hackable, file explorer in rust
    zsh
  ];

  nixpkgs.config.allowUnfree = true;

  # X11 resources
  home.file.".Xresources".source = ./.Xresources;

  # Using keepassxc for secret service 
  programs.keepassxc.enable = true;

  sops = {
    # TODO: need to use mkDefault/mkOverride for systems that aren't nebula
    age.keyFile = "/home/nebula/.config/sops/age/keys.txt";
    # TODO: relative path
    defaultSopsFile = "/home/nebula/nixos-starship/secrets/secrets.yaml";
    defaultSopsFormat = "yaml";
    validateSopsFiles = false;
    # TODO: need to use mkDefault/mkOverride for systems that aren't nebula
    secrets = {
      # To edit:
      # $ nix-shell -p sops --run "sops secrets/secrets.yaml"
      "nano-gpt_key" = {
      };
      "iamb_config" = {
        #owner = "nebula";  # The user who should own the file
        #group = "users";          # The group that should own the file
        #mode = "0600";            # File permissions (600 = owner read/write only)
        path = "/home/nebula/.local/state/nixpak/iamb/config/iamb/config.toml";  # Destination path for nixpak sandbox
      };
    };
  };

}
