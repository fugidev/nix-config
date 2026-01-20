{ pkgs, lib, machineConfig, ... }:
let
  user = "sekuriti";
in
{
  environment.systemPackages = with pkgs; [
    v4l-utils
  ];

  users.groups.${user} = { };
  users.users.${user} = {
    isSystemUser = true;
    group = user;
    extraGroups = [ "video" ];
  };

  services.nginx.virtualHosts."sekuriti.${machineConfig.baseDomain}".locations."/" = {
    root = "/var/lib/sekuriti";
    extraConfig = ''
      autoindex on;
      autoindex_exact_size off;
    '';
  };

  systemd.services."sekuriti" = {
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      User = user;
      Group = user;
      StateDirectory = user;

      Restart = "always";
      ExecStart = "${lib.getExe pkgs.ffmpeg} -i /dev/video0 -c:a copy -c:v libx264 -crf 23 -segment_time 00:05:00 -f segment -reset_timestamps 1 -strftime 1 /var/lib/sekuriti/%%Y-%%m-%%d_%%H-%%M-%%S.mp4";

      # systemd-analyze --no-pager security sekuriti.service
      NoNewPrivileges = true;
      PrivateTmp = true;
      PrivateNetwork = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      ProtectControlGroups = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectKernelLogs = true;
      ProtectClock = true;
      ProtectHostname = true;
      # RestrictAddressFamilies = "AF_INET AF_INET6";
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      MemoryDenyWriteExecute = true;
      LockPersonality = true;
      CapabilityBoundingSet = null;
      PrivateUsers = true;
      SystemCallFilter = "@system-service";
      SystemCallArchitectures = "native";
    };
  };
}
