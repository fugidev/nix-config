{ ... }:
{
  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
    onActivation.upgrade = true;
    onActivation.autoUpdate = true;
    global.brewfile = true;
    enableZshIntegration = true;

    casks = [
      "adobe-acrobat-reader"
      "affinity"
      "android-platform-tools"
      "ausweisapp"
      "bambu-studio"
      "blender"
      "coconutbattery"
      "discord"
      "dockdoor"
      "eclipse-dsl"
      "hex-fiend"
      "inkscape"
      "instant-space-switcher"
      "karabiner-elements"
      "keka"
      "librewolf"
      "linearmouse"
      "localsend"
      "naps2"
      "musicbrainz-picard"
      "prismlauncher"
      "signal"
      "spotify"
      "stats"
      "steam"
      "stolendata-mpv"
      "textmate"
      "thunderbird"
      "vscodium"
      "whichspace"

      # fonts
      "font-atkinson-hyperlegible-next"
      "font-atkinson-hyperlegible-mono"
    ];

    taps = [
      {
        name = "jurplel/tap";
        trusted = true;
      }
    ];

    masApps = {
      WireGuard = 1451685025;
      Xcode = 497799835;
      Bitwarden = 1352778147;
      eduVPN = 1317704208;
    };
  };
}
