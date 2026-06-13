{ ... }:
{
  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
    onActivation.upgrade = true;
    global.brewfile = true;
    enableZshIntegration = true;

    casks = [
      "adobe-acrobat-reader"
      "affinity"
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
