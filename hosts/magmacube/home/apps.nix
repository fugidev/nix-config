{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mkvtoolnix
    libreoffice-fresh
    kdePackages.okular
    kdePackages.kdenlive
    inkscape
    audacity
    spotify
    joplin-desktop
    audio-sharing

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
