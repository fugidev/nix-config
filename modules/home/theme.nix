{ lib, pkgs, ... }: {
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
  };

  qt = {
    enable = lib.mkDefault true;
    platformTheme = "gtk";
  };
}
