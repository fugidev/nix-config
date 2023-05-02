{ config, pkgs, lib, ... }: {

  imports = [
    ./zsh.nix
    ./helix.nix
  ];

  home.username = "root";
  home.homeDirectory = "/root";
}
