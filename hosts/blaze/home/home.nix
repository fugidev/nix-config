{ pkgs, ... }:
{
  fugi.wallpaper = pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath;

  home.pointerCursor.size = 24;
  home.stateVersion = "22.05";
}
