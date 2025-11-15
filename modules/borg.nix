{ config, lib, pkgs, ... }:
{
  imports = [
    # shorter alias for borg repositories setting
    (lib.mkAliasOptionModule
      [ "fugi" "borgRepositories" ]
      [ "services" "borgmatic" "settings" "repositories" ]
    )
  ];

  sops.secrets = {
    "backup/borg_key" = { };
    "backup/sshkey" = { };
    "backup/monitor_token" = { };
  };

  services.borgmatic = {
    enable = true;

    settings = {
      source_directories = [
        "/home"
        "/root"
        "/etc"
        "/var/lib"
        "/var/log"
      ];
      exclude_patterns = [
        "/home/*/.cache"
        "/home/**/site-packages"
        "/home/**/node_modules"
      ];
      exclude_if_present = [
        ".nobackup"
      ];
      exclude_caches = true;

      encryption_passcommand = "${pkgs.coreutils}/bin/cat ${config.sops.secrets."backup/borg_key".path}";

      compression = "zstd";

      ssh_command = "ssh -i ${config.sops.secrets."backup/sshkey".path}";

      keep_daily = 7;
      keep_weekly = 4;
      keep_monthly = 12;

      checks = [{
        name = "repository";
        frequency = "2 weeks";
      }];

      commands =
        let
          pushStatusScript =
            status:
            pkgs.writeScript "borgmatic-push-status-${status}" ''
              token=$(cat ${config.sops.secrets."backup/monitor_token".path})
              ${lib.getExe pkgs.curl} -sSLG \
                -d "status=${status}" \
                "https://status.shepherd.fugi.dev/api/push/$token"
            '';
        in
        [
          {
            after = "everything";
            run = [ (pushStatusScript "up") ];
          }
          {
            after = "error";
            run = [ (pushStatusScript "down") ];
          }
        ];
    };
  };

  # don't potentially kill and restart running backup on system activation
  systemd.services.borgmatic.restartIfChanged = false;

  systemd.timers.borgmatic.timerConfig = {
    RandomizedDelaySec = "2h";
    FixedRandomDelay = true;
    OnCalendar = [
      ""
      "*-*-* 3:00:00"
    ];
  };
}
