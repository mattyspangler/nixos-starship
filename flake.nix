{
  description = "Matty Spangler's Ridiculously Cosmically Ultra-Mega Meta-post-flake Beyond Flakes To End All Flakes"; # Go read some "ground of being" philosophy!

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05"; # slightly behind regular nixos ver
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.6.0"; # remember to update
    # nix-flatpak.url = "github:gmodena/nix-flatpak"; # unstable
    # Watch this PR for age + fido2-hmac support:
    #sops-nix.url = "github:NovaViper/sops-nix";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    nix-ld.url = "github:Mic92/nix-ld";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";

    mcp-nixos = {
      url = "github:utensils/mcp-nixos";
    };

    # Non-flake repos
    doomemacs = {
      url = "github:doomemacs/doomemacs";
      flake = false;
    };

  };

  outputs = inputs @
    { self
    , nixpkgs
    , nixos-hardware
    , nix-on-droid
    , home-manager
    , nix-flatpak
    , sops-nix
    , nix-ld
    , doomemacs
    , ...
    }:
    let
      inherit (self) outputs;
      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {

      # Your custom packages
      # Accessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

      # Formatter for your nix files, available through 'nix fmt'
      # Other options beside 'alejandra' include 'nixpkgs-fmt'
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays {inherit inputs;};
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      nixosConfigurations = {

        gaming-desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./common/core
            ./common/desktop
            ./machines/gaming-desktop
            sops-nix.nixosModules.sops

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs doomemacs; };
              };
              home-manager.users."nebula".imports = [
                nix-flatpak.homeManagerModules.nix-flatpak
                ./common/home-manager/core
                ./common/home-manager/desktop
                ./machines/gaming-desktop/home-manager
                sops-nix.homeManagerModules.sops
              ];
              # Do not change unless you read home-manager release notes,
              # this is for home-manager backwards compatibility:
              home-manager.users.nebula.home.stateVersion = "24.05";
            }
          ];
        };

        vm-workstation = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./common/core
            ./common/desktop
            ./machines/vm-workstation
            sops-nix.nixosModules.sops


            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs doomemacs; };
              };
              home-manager.users."library".imports = [
                nix-flatpak.homeManagerModules.nix-flatpak
                ./common/home-manager/core
                ./common/home-manager/desktop
                ./machines/vm-workstation/home-manager
                sops-nix.homeManagerModules.sops
              ];
             # Do not change unless you read home-manager release notes,
             # this is for home-manager backwards compatibility:
              home-manager.users.library.home.stateVersion = "24.05";
            }
          ];
        };

        k3s-server-master = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./common/core
            ./common/server
            ./machines/vm-server
            ./machines/k3s-server-master
            sops-nix.nixosModules.sops


            #home-manager.nixosModules.home-manager
            #{
            #  home-manager.useGlobalPkgs = true;
            #  home-manager.useUserPackages = true;
            #  home-manager.extraSpecialArgs = { inherit inputs doomemacs; };
            #  home-manager.users."library".imports = [
            #    nix-flatpak.homeManagerModules.nix-flatpak
            #    ./common/home-manager/core
            #    #./common/home-manager/desktop
            #    #./machines/media-server/home-manager
            #    sops-nix.homeManagerModules.sops
            #  ];
              # Do not change unless you read home-manager release notes,
              # this is for home-manager backwards compatibility:
            #  home-manager.users.nebula.home.stateVersion = "24.05";
            #}
          ];
        };

        k3s-server-agent = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./common/core
            ./common/server
            ./machines/vm-server
            ./machines/k3s-server-agent
            sops-nix.nixosModules.sops

            #home-manager.nixosModules.home-manager
            #{
            #  home-manager.useGlobalPkgs = true;
            #  home-manager.useUserPackages = true;
            #  home-manager.extraSpecialArgs = { inherit inputs doomemacs; };
            #  home-manager.users."library".imports = [
            #    nix-flatpak.homeManagerModules.nix-flatpak
            #    ./common/home-manager/core
            #    #./common/home-manager/desktop
            #    #./machines/media-server/home-manager
            #    sops-nix.homeManagerModules.sops
            #  ];
              # Do not change unless you read home-manager release notes,
              # this is for home-manager backwards compatibility:
            #  home-manager.users.nebula.home.stateVersion = "24.05";
            #}
          ];
        };

        k3s-server-agent-2 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./common/core
            ./common/server
            ./machines/vm-server
            ./machines/k3s-server-agent-2
            sops-nix.nixosModules.sops

            #home-manager.nixosModules.home-manager
            #{
            #  home-manager.useGlobalPkgs = true;
            #  home-manager.useUserPackages = true;
            #  home-manager.extraSpecialArgs = { inherit inputs doomemacs; };
            #  home-manager.users."library".imports = [
            #    nix-flatpak.homeManagerModules.nix-flatpak
            #    ./common/home-manager/core
            #    #./common/home-manager/desktop
            #    #./machines/media-server/home-manager
            #    sops-nix.homeManagerModules.sops
            #  ];
              # Do not change unless you read home-manager release notes,
              # this is for home-manager backwards compatibility:
            #  home-manager.users.nebula.home.stateVersion = "24.05";
            #}
          ];
        };

        # TODO: fill out
        secure-laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./machines/secure-laptop
            sops-nix.nixosModules.sops

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = inputs;
              };
              home-manager.users."nebula".imports = [
                ./home/base
                ./home/laptop
                sops-nix.homeManagerModules.sops
              ];
            }
          ];
        };

        # TODO: fill out
        hacking-uconsole = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./common/core
            ./machines/hacking-uconsole
            ./common/desktop-arm
            sops-nix.nixosModules.sops

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = inputs { inherit inputs doomemacs; };
              };
              home-manager.users."nebula".imports = [
                ./common/home-manager/core
                ./common/home-manager/desktop-arm
                sops-nix.homeManagerModules.sops
              ];
            }
          ];
        };

        # TODO: fill out
        hacking-devterm = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./machines/hacking-devterm
            sops-nix.nixosModules.sops

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = inputs;
              };
              home-manager.users."nebula".imports = [
                ./home/base
                ./home/handheld
                sops-nix.homeManagerModules.sops
              ];
            }
          ];
        };

        # This is not in use until NixOS Mobile supports Librem 5, leaving as a placeholder.
        secure-librem5 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./machines/secure-librem5
            ./common/core
            sops-nix.nixosModules.sops

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = inputs;
              };
              home-manager.users."nebula".imports = [
                ./common/home-manager/core
                ./machines/secure-librem5/home-manager
                sops-nix.homeManagerModules.sops
              ];
            }
          ];
        };

        # TODO: fill out
        pinephone-pro = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./common/core
            ./machines/pinephone-pro
            sops-nix.nixosModules.sops

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs doomemacs; };
              };
              home-manager.users."nebula".imports = [
                nix-flatpak.homeManagerModules.nix-flatpak
                ./common/home-manager/core
                #./machines/pinephone-pro/home-manager
                sops-nix.homeManagerModules.sops
              ];
              home-manager.users.nebula.home.stateVersion = "24.11";
            }
          ];

        };

      }; # nixosConfigurations block end

      # Standalone home-manager configurations

      # I use my standalones on silverblue, here's a tutorial for installing home-manager:
      # https://julianhofer.eu/blog/01-silverblue-nix/
      # How to switch:
      # $ home-manager switch --extra-experimental-features 'nix-command flakes' --flake .#user@standalone-dev
      homeConfigurations = {
        "user@standalone-dev" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {inherit inputs outputs doomemacs;};
          # > Our main home-manager configuration file <
          modules = [./common/home-manager/core
                     ./common/home-manager/standalone
                     sops-nix.homeManagerModules.sops
                    ];
        };

        # Standalone environment for PostmarketOS on Librem 5
        "nebula@libremfive" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {inherit inputs outputs doomemacs;};
          # > Our main home-manager configuration file <
          modules = [
                      nix-flatpak.homeManagerModules.nix-flatpak
                      nix-ld.nixosModules.nix-ld
                      ./common/home-manager/core
                      ./machines/secure-librem5/home-manager
                      sops-nix.homeManagerModules.sops
                      { programs.nix-ld.enable = true; }
                    ];
        };

      }; # homeConfigurations block end

      # Android Nix configuration
      nixOnDroidConfigurations.android-tablet = nix-on-droid.lib.nixOnDroidConfiguration {
        system = "aarch64-linux";
        modules = [
          ./machines/android-tablet
          ./common/nix-on-droid

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs doomemacs; };
              config = ./common/home-manager/nix-on-droid;
            };
          }
        ];
      };

    }; # output block
}
