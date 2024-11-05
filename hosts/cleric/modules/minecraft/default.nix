{ lib, pkgs, inputs, util, ... }:
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    dataDir = "/var/lib/minecraft";
    managementSystem = {
      tmux.enable = false;
      systemd-socket.enable = true;
    };
    servers = builtins.mapAttrs
      (name: path: import path { inherit lib pkgs; })
      (util.dirPathsNamed ./servers);
  };

  fugi.allowUnfree = [ "minecraft-server" ];
}
