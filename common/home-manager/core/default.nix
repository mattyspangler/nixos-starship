{
  config,
  pkgs,
  ...
}: {

  imports = [
    ./emacs
    ./ml
    ./zsh
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
  ];

  nixpkgs.config.allowUnfree = true;

  sops = {
    # TODO: need to use mkDefault/mkOverride for systems that aren't nebula
    age.keyFile = "/home/nebula/.config/sops/age/keys.txt";
    # TODO: relative path
    defaultSopsFile = "/home/nebula/nix-starship/secrets/secrets.yaml";
    defaultSopsFormat = "yaml";
    validateSopsFiles = false;
    # TODO: need to use mkDefault/mkOverride for systems that aren't nebula
    secrets = {
      # To edit:
      # $ nix-shell -p sops --run "sops secrets/secrets.yaml"
      "nano-gpt_key" = {
      };
    };
  };

}
