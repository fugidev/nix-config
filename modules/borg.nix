{ config, pkgs, ... }:
{
  sops.secrets = {
    borg_key = { };
    borg_sshkey = { };
    pushover_token = { };
    pushover_user = { };
  };

  services.borgmatic = {
    enable = true;

    settings = {
      location = {
        source_directories = [
          "/home"
          "/root"
          "/etc"
          "/var/lib"
          "/var/log"
        ];
        repositories = config.fugi.borgRepositories;
        exclude_caches = true;
      };

      storage = {
        encryption_passcommand = "${pkgs.coreutils}/bin/cat ${config.sops.secrets.borg_key.path}";
        compression = "zstd";
        ssh_command = "ssh -i ${config.sops.secrets.borg_sshkey.path}";
      };

      retention = {
        keep_daily = 7;
        keep_weekly = 4;
        keep_monthly = 12;
      };

      consistency.checks = [{
        name = "repository";
        frequency = "2 weeks";
      }];

      hooks = {
        on_error = [
          ''
            ${pkgs.curl}/bin/curl -s \
              -F "token=<${config.sops.secrets.pushover_token.path}" \
              -F "user=<${config.sops.secrets.pushover_user.path}" \
              -F "message=${config.networking.hostName}: Backup failed!" \
              https://api.pushover.net/1/messages.json
          ''
        ];
      };
    };
  };

  systemd.timers.borgmatic.timerConfig = {
    RandomizedDelaySec = "2h";
    OnCalendar = [
      ""
      "*-*-* 3:00:00"
    ];
  };
}
