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

    # social
    element-desktop
    discord
    (makeAutostartItem {
      name = "signal";
      package = signal-desktop;
      appendExtraArgs = [ "--start-in-tray" ];
    })
  ];
}
