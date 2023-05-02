{ config, pkgs, lib, ... }: {

  imports = [
    ./zsh.nix
    ./git.nix
    ./foot.nix
    ./direnv.nix
    ./helix.nix
    ./dunst.nix
  ];

  home.username = "fugi";
  home.homeDirectory = "/home/fugi";

  home.packages = lib.mkIf (config.fugi.guiApps) (with pkgs; [
    qalculate-gtk
    remmina
  ]);
}
