{ lib, pkgs, ... }:
let
  gtkExtraCss = ''
    decoration { box-shadow: none; }
    decoration:backdrop { box-shadow: none; }
  '';
in
{
  home.pointerCursor = {
    package = pkgs.apple-cursor;
    name = "macOS-Monterey";

    x11.enable = true;
    gtk.enable = true;
  };

  gtk = {
    enable = true;

    iconTheme = {
      package = pkgs.breeze-icons;
      name = "breeze-dark";
    };

    theme = {
      package = pkgs.breeze-gtk;
      name = "Breeze-Dark";
    };

    gtk3.extraCss = gtkExtraCss;
    gtk4.extraCss = gtkExtraCss;
  };

  qt = {
    enable = lib.mkDefault true;
    platformTheme = "gtk";
  };
}
