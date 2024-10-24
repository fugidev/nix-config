{ pkgs, ... }:
{
  home.packages = with pkgs; [
    komikku
    mkvtoolnix
    libreoffice-fresh
    kdePackages.okular
    element-desktop
    discord
    tenacity
    spotify
    prismlauncher
    vdhcoapp
  ];
}
