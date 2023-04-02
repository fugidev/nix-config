{ config, pkgs, lib, ... }: {

  imports = [
    ./base.nix
    ./zsh.nix
    ./nvim.nix
  ];

  home.username = "root";
  home.homeDirectory = "/root";
}
