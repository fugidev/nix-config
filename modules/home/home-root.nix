{ config, pkgs, lib, ... }: {

  imports = [
    ./base.nix
    ./zsh.nix
    ./neovim
    ./helix.nix
  ];

  home.username = "root";
  home.homeDirectory = "/root";
}
