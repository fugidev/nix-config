{ config, pkgs, lib, ... }: {

  imports = [
    ./user-options.nix
    ./zsh.nix
    ./git.nix
    ./foot.nix
    ./direnv.nix
    ./helix.nix
    ./dunst.nix
  ];

  home.username = "fugi";
  home.homeDirectory = "/home/fugi";

  home.packages = with pkgs; [
    gopass
  ] ++ lib.optionals config.fugi.guiApps [
    qalculate-gtk
    remmina
  ];
}
