{ config, pkgs, lib, ... }: {

  imports = [
    ./base.nix
    ./zsh.nix
    ./git.nix
    ./foot.nix
    ./direnv.nix
    ./neovim
    ./helix.nix
  ];

  home.username = "fugi";
  home.homeDirectory = "/home/fugi";

  home.packages = lib.mkIf (config.fugi.guiApps) (with pkgs; [
    qalculate-gtk
  ]);
}
