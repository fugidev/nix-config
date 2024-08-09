{
  description = "fugi's nixos configuration";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
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
      url = "github:nix-community/home-manager/release-24.05";
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
  };

  outputs = inputs:
    let
      mkNixosSystem = (
        {
          hostName,
          system,
          nixpkgs,
          home-manager ? null,
          modules ? [],
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            flakeRoot = inputs.self;
          };
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
      blaze = mkNixosSystem {
        hostName = "blaze";
        system = "aarch64-linux";
        nixpkgs = nixpkgs-unstable;
        home-manager = home-manager;
        modules = [
          nixos-asahi.nixosModules.default
          ./modules/greetd.nix
          ./modules/fonts.nix
          ./modules/printing.nix
          ./modules/ios-support.nix
          {
            fugi.promptColor = "#f7ce46"; # yellow
            programs.sway.enable = true;
            xdg.portal.enable = true;

            home-manager = {
              users.fugi.imports = [
                ./modules/home/home-fugi.nix
                ./modules/home/mail.nix
                ./modules/home/ssh.nix
                ./modules/home/gpg.nix
                ./hosts/blaze/sway.nix
                ({ pkgs, ... }: {
                  fugi.wallpaper = pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath;
                  fugi.guiApps = true;

                  home.pointerCursor.size = 24;
                  home.stateVersion = "22.05";
                })
              ];
            };
          }
        ];
      };

      librarian = mkNixosSystem {
        hostName = "librarian";
        system = "x86_64-linux";
        nixpkgs = nixpkgs-stable;
        home-manager = home-manager-stable;
        modules = [
          sops-nix.nixosModules.sops
          ./modules/sops.nix
          ./modules/nginx.nix
          ./modules/borg.nix
          (home-root "23.05")
          {
            sops.defaultSopsFile = ./hosts/librarian/secrets.yaml;

            fugi.borgRepositories = [{
              path = "ssh://u329990-sub1@u329990-sub1.your-storagebox.de:23/./borg-repository";
              label = "storagebox";
            }];
          }
        ];
      };

      nitwit = mkNixosSystem {
        hostName = "nitwit";
        system = "x86_64-linux";
        nixpkgs = nixpkgs-stable;
        home-manager = home-manager-stable;
        modules = [
          sops-nix.nixosModules.sops
          ./modules/sops.nix
          ./modules/nginx.nix
          (home-root "23.11")
          {
            sops.defaultSopsFile = ./hosts/nitwit/secrets.yaml;
          }
        ];
      };

      shepherd = mkNixosSystem {
        hostName = "shepherd";
        system = "aarch64-linux";
        nixpkgs = nixpkgs-stable;
        home-manager = home-manager-stable;
        modules = [
          nixos-hardware.nixosModules.raspberry-pi-4
          sops-nix.nixosModules.sops
          ./modules/sops.nix
          ./modules/nginx.nix
          (home-root "24.05")
          {
            sops.defaultSopsFile = ./hosts/shepherd/secrets.yaml;
          }
        ];
      };
    };

    homeConfigurations = {
      "fugi@magmacube" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs-unstable.legacyPackages."x86_64-linux";
        extraSpecialArgs = {
          inherit inputs;
          flakeRoot = inputs.self;
        };

        modules = [
          ./modules/home/home-fugi.nix
          ./modules/home/ssh.nix
          ./hosts/magmacube/sway.nix
          ({ pkgs, ... }: {
            nix.registry.nixpkgs.flake = inputs.nixpkgs-unstable;
            programs.home-manager.enable = true;

            fugi.wallpaper = pkgs.fetchurl {
              url = "https://web.archive.org/web/20230404203951if_/https://images.wallpapersden.com/image/download/macos-12-monterey-digital_bG1mZ2mUmZqaraWkpJRpbW5trWlpamc.jpg";
              sha256 = "NA4nhCcnT6B9IJQWh8ldnjSt9eUFmte6AfN3cNz8Fwk=";
            };
            fugi.promptColor = "#ff8700"; # orange

            home.pointerCursor.size = 28;
            home.stateVersion = "22.05";
          })
        ];
      };

      "fugi@blaze" = home-manager-stable.lib.homeManagerConfiguration {
        pkgs = nixpkgs-stable.legacyPackages."aarch64-darwin";
        extraSpecialArgs = {
          inherit inputs;
          flakeRoot = inputs.self;
        };

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
            ./modules/zsh.nix
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
            ./modules/zsh.nix
          ];
        };
      };
    };
  };
}
