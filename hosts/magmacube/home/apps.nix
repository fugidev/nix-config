{ pkgs, ... }:
{
  home.packages = with pkgs; [
    komikku
    mkvtoolnix
    libreoffice-fresh
    kdePackages.okular
    kdePackages.kdenlive
    inkscape
    element-desktop
    discord
    tenacity
    spotify
    prismlauncher
    vdhcoapp

    freecad
    bambu-studio
  ];
}
