{ config, pkgs, lib, ... }: {

  imports = [
    ./base.nix
    ./nvim.nix
    ./git.nix
    ./foot.nix
    ./direnv.nix
  ];

  home.username = "fugi";
  home.homeDirectory = "/home/fugi";

  home.packages = lib.mkIf (config.fugi.guiApps) (with pkgs; [
    qalculate-gtk
  ]);
}
