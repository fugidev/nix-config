{ pkgs, ... }:
{
  systemd.services."asahi-bless-reboot" = {
    wantedBy = [ "reboot.target" ];
    before = [
      "systemd-reboot.service"
      "reboot.target"
    ];
    path = [ pkgs.asahi-bless ];

    script = ''
      asahi-bless --next --set-boot NixOS -y
    '';

    unitConfig.DefaultDependencies = "no";

    serviceConfig = {
      Type = "oneshot";
      User = "root";
      RemainAfterExit = "yes";
      Restart = "no";
    };
  };
}
