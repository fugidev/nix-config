{ ... }:
{
  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
    onActivation.upgrade = true;

    casks = [
      "bambu-studio"
      "inkscape"
      "jellyfin-media-player"
      "kdenlive"
      "linearmouse"
      "naps2"
      "prismlauncher"
      "rectangle"
      "stats"
      "stolendata-mpv"
      "vscodium"
      "signal"
      {
        name = "librewolf";
        args.no_quarantine = true;
      }
    ];
  };
}
