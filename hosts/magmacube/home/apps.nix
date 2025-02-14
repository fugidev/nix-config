{ pkgs, ... }:
{
  home.packages = with pkgs; [
    komikku
    mkvtoolnix
    libreoffice-fresh
    kdePackages.okular
    kdePackages.kdenlive
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
