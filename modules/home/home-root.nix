{ config, pkgs, lib, ... }: {

  imports = [
    ./base.nix
    ./zsh.nix
    ./neovim
  ];

  home.username = "root";
  home.homeDirectory = "/root";
}
