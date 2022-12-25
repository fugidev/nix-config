{ config, pkgs, lib, ... }: {
  programs.rofi = {
    enable = true;

    theme = "Arc-Dark";
    font = "mono 18";

    extraConfig = {
      modi = "drun";
      show-icons = true;
    };
  };

  home.packages = [ pkgs.rofimoji ];
}
