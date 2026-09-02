{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.droppedneedle;
in
{
  options.services.droppedneedle = {
    enable = lib.mkEnableOption "DroppedNeedle, a self-hosted music library and discovery service";

    package = lib.mkPackageOption pkgs "droppedneedle" { };

    hostName = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      description = "Hostname to serve DroppedNeedle on via nginx.";
    };

    slskdDownloadsPath = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
    };

    sabnzbdDownloadsPath = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
    };

    extraReadWritePaths = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = ''
        Filesystem paths the service should have read/write access to in
        addition to slskd and sabnzbd download folders, e.g. library folders.
      '';
    };

    extraGroups = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = ''
        Additional groups the service user should run with.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.droppedneedle = {
      slskdDownloadsPath = lib.mkIf config.services.slskd.enable (
        lib.mkDefault config.services.slskd.settings.directories.downloads
      );
    };

    systemd.services.droppedneedle = {
      description = "DroppedNeedle";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        ROOT_APP_DIR = "/var/lib/droppedneedle";
        ${if (cfg.slskdDownloadsPath != null) then "SLSKD_DOWNLOADS_PATH" else null} =
          cfg.slskdDownloadsPath;
      };

      serviceConfig = {
        Type = "exec";
        DynamicUser = true;
        SupplementaryGroups = cfg.extraGroups;
        RuntimeDirectory = "droppedneedle";
        StateDirectory = "droppedneedle";
        ExecStartPre = "${lib.getExe' cfg.package "python"} -m maintenance.automatic_upgrade";
        ExecStart = "${lib.getExe cfg.package} --uds \${RUNTIME_DIRECTORY}/droppedneedle.sock";
        Restart = "on-failure";
        ReadWritePaths = [
          cfg.slskdDownloadsPath
          cfg.sabnzbdDownloadsPath
        ]
        ++ cfg.extraReadWritePaths;

        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectKernelLogs = true;
        ProtectClock = true;
        ProtectHostname = true;
        RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX";
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

    services.nginx = lib.mkIf (cfg.hostName != null) {
      virtualHosts."${cfg.hostName}" = {
        locations."/" = {
          proxyPass = "http://unix:/run/droppedneedle/droppedneedle.sock";
          proxyWebsockets = true;
          extraConfig = ''
            client_max_body_size 100M;
            proxy_buffering off;
          '';
        };
      };
    };
  };
}
