{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mkvtoolnix
    libreoffice-fresh
    kdePackages.okular
    kdePackages.kdenlive
    inkscape
    tenacity
    spotify
    vdhcoapp
    joplin-desktop

    freecad
    # bambu-studio

    # games
    prismlauncher
    lutris
    vintagestory

    # social
    element-desktop
    discord
    signal-desktop
    tuba
  ];
}
