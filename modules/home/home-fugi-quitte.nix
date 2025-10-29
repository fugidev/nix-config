{ config, lib, ... }:
{
  imports = [
    ./helix.nix
    ./zsh.nix
  ];

  home.stateVersion = "25.11";
  home.username = "fugi";
  home.homeDirectory = "/home/users/fugi";

  programs.nh = {
    enable = true;
    flake = "$HOME/.config/home-manager";
  };
}
