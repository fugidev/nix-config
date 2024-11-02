{ lib, flakeRoot, ... }:
{
  imports = [
    (flakeRoot + /modules/borg.nix)
  ];

  services.borgmatic.settings = {
    repositories = [{
      path = "ssh://borg@librarian.fugi.dev/./.";
      label = "librarian";
    }];

    exclude_patterns = [
      "/home/fugi/.local/share/Steam"
    ];

    keep_within = "24H";
    keep_hourly = 4;
    keep_monthly = lib.mkForce 6;
  };

  systemd.timers.borgmatic.timerConfig = {
    RandomizedDelaySec = lib.mkForce 0;
    OnCalendar = lib.mkForce "";
    OnStartupSec = "2min";
    OnUnitActiveSec = "4h";
  };
}
