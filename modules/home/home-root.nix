{ config, pkgs, lib, ... }: {

  imports = [
    ./base.nix
    ./nvim.nix
  ];

  home.username = "root";
  home.homeDirectory = "/root";
}
