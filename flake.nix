{
  description = "fugi's nixos configuration";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      nixbook = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          ./hosts/nixbook/configuration.nix
          ./modules/xorg.nix
          ./modules/fonts.nix
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              users.fugi.imports = [
                ./modules/home/home-fugi.nix
                ./modules/home/i3.nix
                ./modules/home/user-options.nix
                ({ pkgs, ... }: {
                  fugi.wallpaper = pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath;
                })
              ];

              users.root = import ./modules/home/home-root.nix;
            };
          }
        ];
      };
    };
  };
}
