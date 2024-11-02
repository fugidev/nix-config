{ config, lib, pkgs, ... }:
{
  imports = [
    # shorter alias for borg repositories setting
    (lib.mkAliasOptionModule [ "fugi" "borgRepositories" ] [ "services" "borgmatic" "settings" "repositories" ])
  ];

  sops.secrets = {
    borg_key = { };
    borg_sshkey = { };
    pushover_token = { };
    pushover_user = { };
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

      encryption_passcommand = "${pkgs.coreutils}/bin/cat ${config.sops.secrets.borg_key.path}";

      compression = "zstd";

      ssh_command = "ssh -i ${config.sops.secrets.borg_sshkey.path}";

      keep_daily = 7;
      keep_weekly = 4;
      keep_monthly = 12;

      checks = [{
        name = "repository";
        frequency = "2 weeks";
      }];

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

  systemd.timers.borgmatic.timerConfig = {
    RandomizedDelaySec = "2h";
    OnCalendar = [
      ""
      "*-*-* 3:00:00"
    ];
  };
}
