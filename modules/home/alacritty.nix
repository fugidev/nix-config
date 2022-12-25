{ config, pkgs, lib, ... }: {
  programs.alacritty = {
    enable = true;

    settings = {
      font = {
        normal.family = "Fira Code";
        size = 14;
      };

      colors = {
        primary = {
          background = "#14191e";
          foreground = "#c5c8c6";
        };
        normal = {
          black = "#090909";
          red = "#eb4e3d";
          green = "#76d672";
          yellow = "#f7ce46";
          blue = "#4193f7";
          magenta = "#eb445a";
          cyan = "#78c5f5";
          white = "#ffffff";
        };
        bright = {
          black = "#686868";
          red = "#eb4e3d";
          green = "#76d672";
          yellow = "#f7ce46";
          blue = "#4193f7";
          magenta = "#eb445a";
          cyan = "#78c5f5";
          white = "#ffffff";
        };
      };

      cursor.style.shape = "Beam";
    };
  };
}
