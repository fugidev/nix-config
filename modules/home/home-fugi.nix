{ config, pkgs, lib, ... }: {

  imports = [
    ./base.nix
    ./nvim.nix
    ./git.nix
    ./alacritty.nix
  ];

  home.username = "fugi";
  home.homeDirectory = "/home/fugi";
}
