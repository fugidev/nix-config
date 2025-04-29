{
  description = "fugi's nixos configuration";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    flake-utils.url = "github:numtide/flake-utils";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nixos-asahi = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    exam-poll = {
      url = "git+https://codeberg.org/fugi/exam-poll.git";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = inputs:
    let
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
          modules ? [],
        }:
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules =
            [
              ./hosts/${hostName}
              ./modules/base.nix
              ./modules/machines.nix
              ({ config, ... }: {
                _module.args.machineConfig = config.fugi.machines.${hostName};
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
          modules ? [],
        }:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = specialArgs;
          modules =
            [{
              nix.registry.nixpkgs.flake = inputs.nixpkgs-unstable;
              programs.home-manager.enable = true;
              programs.zsh.sessionVariables = {
                NIX_PATH = "nixpkgs=${inputs.nixpkgs-unstable}";
              };
            }]
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
          nixos-asahi.nixosModules.default
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

    homeConfigurations = {
      "fugi@blaze" = mkHome {
        home-manager = home-manager-stable;
        pkgs = nixpkgs-stable.legacyPackages."aarch64-darwin";

        modules = [
          ./modules/home/home-fugi-darwin.nix
          {
            fugi.promptColor = "#f7ce46"; # yellow
            home.stateVersion = "24.05";
          }
        ];
      };
    };

    formatter = flake-utils.lib.eachDefaultSystemMap (
      system: nixpkgs-unstable.legacyPackages.${system}.nixpkgs-fmt
    );

    packages = {
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
  };
}
