{
  description = "fugi's nixos configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nixos-asahi = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: with inputs; {
    nixosConfigurations = {
      blaze = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          nixos-asahi.nixosModules.default
          home-manager.nixosModules.home-manager
          ./hosts/blaze
          ./modules/base.nix
          ./modules/greetd.nix
          ./modules/fonts.nix
          ./modules/printing.nix
          {
            fugi.promptColor = "#f7ce46"; # yellow
            programs.sway.enable = true;
            xdg.portal.enable = true;

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              users.fugi.imports = [
                ./modules/home/home-fugi.nix
                ./modules/home/mail.nix
                ./modules/home/ssh.nix
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

      librarian = nixpkgs-stable.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          sops-nix.nixosModules.sops
          home-manager-stable.nixosModules.home-manager
          ./hosts/librarian
          ./modules/base.nix
          ./modules/sops.nix
          ./modules/nginx.nix
          ./modules/borg.nix
          {
            sops.defaultSopsFile = ./hosts/librarian/secrets.yaml;

            fugi.borgRepositories = [
              "ssh://u329990-sub1@u329990-sub1.your-storagebox.de:23/./borg-repository"
            ];

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              users.root.imports = [
                ./modules/home/home-root.nix
                {
                  home.stateVersion = "23.05";
                }
              ];
            };
          }
        ];
      };
    };

    # magmacube home-manager
    homeConfigurations.fugi = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      extraSpecialArgs = { inherit inputs; };

      modules = [
        ./modules/home/home-fugi.nix
        ./hosts/magmacube/sway.nix
        ({ pkgs, ... }: {
          nix.registry.nixpkgs.flake = inputs.nixpkgs;
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

  } // flake-utils.lib.eachDefaultSystem (system: {
    formatter = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;

    packages.iso = nixos-generators.nixosGenerate {
      inherit system;
      format = "install-iso";
      modules = [
        ./hosts/iso
        ./modules/options.nix
        ./modules/zsh.nix
        # {
        #   networking = {
        #     interfaces.ens3.ipv4.addresses = [{
        #       address = "178.254.28.214";
        #       prefixLength = 22;
        #     }];
        #     defaultGateway = {
        #       address = "178.254.28.1";
        #       interface = "ens3";
        #     };
        #     nameservers = [
        #       "178.254.16.151"
        #       "178.254.16.141"
        #     ];
        #   };
        # }
      ];
    };
  });
}
