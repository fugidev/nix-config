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
      "hex-fiend"
      "inkscape"
      "karabiner-elements"
      "keka"
      "linearmouse"
      "localsend"
      "naps2"
      "musicbrainz-picard"
      "prismlauncher"
      "signal"
      "stats"
      "steam"
      "stolendata-mpv"
      "textmate"
      "thunderbird"
      "vscodium"
      {
        name = "librewolf";
        postinstall = "sudo xattr -r -d com.apple.quarantine /Applications/LibreWolf.app";
      }
    ];

    masApps = {
      WireGuard = 1451685025;
      Xcode = 497799835;
    };
  };
}
