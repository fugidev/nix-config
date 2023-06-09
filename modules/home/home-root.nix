{ config, pkgs, lib, ... }: {

  imports = [
    ./user-options.nix
    ./zsh.nix
    ./helix.nix
  ];

  home.username = "root";
  home.homeDirectory = "/root";
}
