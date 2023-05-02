{
  description = "fugi's nixos configuration";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;

    # gpu does not work on latest unstable
    nixpkgs-blaze.url = github:FugiMuffi/nixpkgs/unstable-blaze;

    sops-nix = {
      url = github:Mic92/sops-nix;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-asahi = {
      url = github:tpwrules/nixos-apple-silicon;
      inputs.nixpkgs.follows = "nixpkgs-blaze";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-blaze, sops-nix, home-manager, nixos-asahi, ... }@inputs: {
    nixosConfigurations = {
      blaze = nixpkgs-blaze.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          nixos-asahi.nixosModules.default
          home-manager.nixosModules.home-manager
          ./hosts/blaze/configuration.nix
          ./modules/base.nix
          ./modules/greetd.nix
          ./modules/fonts.nix
          ./modules/printing.nix
          {
            programs.sway.enable = true;
            xdg.portal.enable = true;

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              users.fugi.imports = [
                ./modules/home/user-options.nix
                ./modules/home/home-fugi.nix
                ./hosts/blaze/sway.nix
                ({ pkgs, ... }: {
                  fugi.wallpaper = pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath;
                  fugi.promptColor = "#f7ce46"; # yellow
                  fugi.guiApps = true;
                  fugi.nvimFull = true;

                  home.pointerCursor.size = 24;
                })
              ];

              users.root = import ./modules/home/home-root.nix;
            };
          }
        ];
      };

      librarian = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          sops-nix.nixosModules.sops
          ./hosts/librarian/configuration.nix
          ./modules/base.nix
          ./modules/sops.nix
          ./modules/nginx.nix
          {
            sops.defaultSopsFile = ./secrets/librarian.yaml;

            fugi.domain = "librarian.fugi.dev";
          }
        ];
      };
    };

    # magmacube home-manager
    homeConfigurations.fugi = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";

      modules = [
        ./modules/home/user-options.nix
        ./modules/home/home-fugi.nix
        ./hosts/magmacube/sway.nix
        ({ pkgs, ... }: {
          programs.home-manager.enable = true;

          fugi.wallpaper = pkgs.fetchurl {
            url = "https://web.archive.org/web/20230404203951if_/https://images.wallpapersden.com/image/download/macos-12-monterey-digital_bG1mZ2mUmZqaraWkpJRpbW5trWlpamc.jpg";
            sha256 = "NA4nhCcnT6B9IJQWh8ldnjSt9eUFmte6AfN3cNz8Fwk=";
          };
          fugi.promptColor = "#ff8700"; # orange
          fugi.nvimFull = true;

          home.pointerCursor.size = 28;
        })
      ];
    };
  };
}
