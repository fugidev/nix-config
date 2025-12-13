{
  description = "fugi's nixos configuration";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    flake-utils.url = "github:numtide/flake-utils";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nixos-apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    inputs:
    let
      forAllSystems = inputs.nixpkgs-unstable.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      pkgsForSystem =
        system: import ./overlay.nix null (import inputs.nixpkgs-unstable { inherit system; });

      specialArgs = {
        inherit inputs;
        flakeRoot = inputs.self;
        util = import ./util inputs.nixpkgs-unstable.lib;
      };

      mkNixosSystem = (
        {
          hostName,
          system,
          nixpkgs,
          home-manager ? null,
          modules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./modules/lix.nix # use lesbiab nix
            ./hosts/${hostName}
            ./modules/base.nix
            ./modules/machines.nix
            ({ config, ... }: {
              _module.args.machineConfig = config.fugi.machines.${hostName};
              nixpkgs.overlays = [ inputs.self.overlays.default ];
            })
          ]
          ++ nixpkgs.lib.optionals (home-manager != null) [
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = specialArgs;
              };
            }
          ]
          ++ modules;
        }
      );

      mkHome = (
        {
          home-manager,
          pkgs,
          modules ? [ ],
        }:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = specialArgs;
          modules = [
            {
              nixpkgs.overlays = [ inputs.self.overlays.default ];
              nix.registry.nixpkgs.flake = inputs.nixpkgs-unstable;
              programs.home-manager.enable = true;
              programs.zsh.sessionVariables = {
                NIX_PATH = "nixpkgs=${inputs.nixpkgs-unstable}";
              };
            }
          ]
          ++ modules;
        }
      );

      home-root = stateVersion: {
        home-manager.users.root = {
          imports = [ ./modules/home/home-root.nix ];
          home = { inherit stateVersion; };
        };
      };
    in
    with inputs;
    {
      nixosConfigurations = {
        magmacube = mkNixosSystem {
          hostName = "magmacube";
          system = "x86_64-linux";
          nixpkgs = nixpkgs-unstable;
          home-manager = home-manager;
          modules = [
            ./modules/desktop.nix
            ./modules/sops.nix
          ];
        };

        blaze = mkNixosSystem {
          hostName = "blaze";
          system = "aarch64-linux";
          nixpkgs = nixpkgs-unstable;
          home-manager = home-manager;
          modules = [
            nixos-apple-silicon.nixosModules.default
            ./modules/desktop.nix
          ];
        };

        librarian = mkNixosSystem {
          hostName = "librarian";
          system = "x86_64-linux";
          nixpkgs = nixpkgs-stable;
          home-manager = home-manager-stable;
          modules = [
            ./modules/sops.nix
            ./modules/nginx.nix
            ./modules/unbound
            ./modules/adguard.nix
            (home-root "23.05")
          ];
        };

        shepherd = mkNixosSystem {
          hostName = "shepherd";
          system = "aarch64-linux";
          nixpkgs = nixpkgs-stable;
          home-manager = home-manager-stable;
          modules = [
            nixos-hardware.nixosModules.raspberry-pi-4
            ./modules/sops.nix
            ./modules/nginx.nix
            ./modules/unbound
            ./modules/adguard.nix
            (home-root "24.05")
          ];
        };

        cleric = mkNixosSystem {
          hostName = "cleric";
          system = "x86_64-linux";
          nixpkgs = nixpkgs-stable;
          home-manager = home-manager-stable;
          modules = [
            ./modules/sops.nix
            ./modules/nginx.nix
            ./modules/unbound
            (home-root "24.05")
          ];
        };
      };

      darwinConfigurations = {
        blaze = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          inherit specialArgs;
          modules = [
            home-manager.darwinModules.home-manager
            {
              nixpkgs.overlays = [ inputs.self.overlays.default ];

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = specialArgs;
              };
            }
            ./modules/lix.nix # use lesbiab nix
            ./modules/base-packages.nix
            ./hosts/blaze-darwin
          ];
        };
      };

      homeConfigurations = {
        "fugi@quitte" = mkHome {
          inherit home-manager;
          pkgs = nixpkgs-unstable.legacyPackages."x86_64-linux";
          modules = [
            ./modules/options.nix
            ./modules/home/home-fugi-quitte.nix
          ];
        };
      };

      packages =
        nixpkgs-unstable.lib.recursiveUpdate
          (forAllSystems pkgsForSystem)
          {
            x86_64-linux = {
              iso = nixos-generators.nixosGenerate {
                system = "x86_64-linux";
                format = "install-iso";
                modules = [
                  ./hosts/iso
                  ./modules/options.nix
                  ./modules/zsh
                ];
              };
            };
            aarch64-linux = {
              raspi-installer = nixos-generators.nixosGenerate {
                system = "aarch64-linux";
                format = "sd-aarch64-installer";
                modules = [
                  nixos-hardware.nixosModules.raspberry-pi-4
                  ./hosts/iso
                  ./hosts/iso/pi4.nix
                  ./modules/options.nix
                  ./modules/zsh
                ];
              };
            };
          };

      overlays.default = import ./overlay.nix;
    };
}
