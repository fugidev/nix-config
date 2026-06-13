{ ... }:
{
  system.defaults.dock = {
    autohide = true;
    show-recents = false;

    wvous-br-corner = 1; # disable bottom right hot corner

    persistent-apps = [
      { app = "/System/Applications/Apps.app"; }
      { app = "/Applications/Nix Apps/Alacritty.app"; }
      { app = "/Applications/Librewolf.app"; }
    ];
  };
}
