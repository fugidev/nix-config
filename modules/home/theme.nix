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
    name = "macOS";

    x11.enable = true;
    gtk.enable = true;
  };

  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  gtk = {
    enable = true;

    iconTheme = {
      package = pkgs.kdePackages.breeze-icons;
      name = "breeze-dark";
    };

    theme = {
      package = pkgs.kdePackages.breeze-gtk;
      name = "Breeze-Dark";
    };

    gtk3.extraCss = gtkExtraCss;

    gtk4.extraCss = gtkExtraCss;
    # disable janky stylesheet override
    gtk4.theme = null;
  };

  qt = {
    enable = lib.mkDefault true;
    platformTheme.name = "gtk";
  };
}
