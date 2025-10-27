{ lib, pkgs, ... }:
{
  systemd.services."asahi-btsync" = {
    description = "Apple silicon Bluetooth device sync";
    after = [ "bluetooth.service" ];
    requisite = [ "bluetooth.service" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
      ExecStart = "${lib.getExe pkgs.asahi-btsync} sync";
    };
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="mtd", ATTR{name}=="nvram", DRIVERS=="apple-spi", TAG+="systemd", ENV{SYSTEMD_WANTS}="asahi-btsync.service"
  '';
}

