{ pkgs, ... }:
{
  home.packages = with pkgs; [
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
    joplin-desktop

    freecad
    bambu-studio

    lutris
    vintagestory
  ];
}
