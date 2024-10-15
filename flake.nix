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
          ./modules/greetd.nix
          ./modules/fonts.nix
          ./modules/printing.nix
          {
            fugi.promptColor = "#ff8700"; # orange
            programs.sway.enable = true;
            xdg.portal.enable = true;

            home-manager = {
              users.fugi.imports = [
                ./modules/home/home-fugi.nix
                ./modules/home/mail.nix
                ./modules/home/ssh.nix
                ./modules/home/gpg.nix
                ({ pkgs, ... }: {
                  fugi.wallpaper = pkgs.fetchurl {
                    url = "https://images.wallpapersden.com/image/download/macos-12-monterey-digital_bG1mZ2mUmZqaraWkpJRpbW5trWlpamc.jpg";
                    # url = "https://web.archive.org/web/20230404203951if_/https://images.wallpapersden.com/image/download/macos-12-monterey-digital_bG1mZ2mUmZqaraWkpJRpbW5trWlpamc.jpg";
                    sha256 = "NA4nhCcnT6B9IJQWh8ldnjSt9eUFmte6AfN3cNz8Fwk=";
                  };
                  fugi.guiApps = true;

                  home.pointerCursor.size = 28;
                  home.stateVersion = "24.05";
                })
              ];
            };
          }
        ];
      };

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
          ./modules/sops.nix
          ./modules/nginx.nix
          ./modules/borg.nix
          ./modules/unbound.nix
          ./modules/adguard.nix
          (home-root "23.05")
          {
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
          ./modules/sops.nix
          ./modules/nginx.nix
          (home-root "23.11")
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
          ./modules/unbound.nix
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
          ./modules/unbound.nix
          ./modules/borg.nix
          (home-root "24.05")
          {
            fugi.borgRepositories = [{
              path = "ssh://u329990-sub5@u329990-sub5.your-storagebox.de:23/./borg-repository";
              label = "storagebox";
            }];
          }
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
