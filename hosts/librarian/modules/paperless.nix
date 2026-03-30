{ config, lib, ... }:
let
  consumptionDir = "/data/lynna/_paperless";
  fqdn = "paperless.${config.networking.fqdn}";
in
{
  services.paperless = {
    enable = true;
    passwordFile = config.sops.secrets.paperless_password.path;
    settings = {
      PAPERLESS_URL = "https://${fqdn}";
      PAPERLESS_DBHOST = "/run/postgresql";
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_OCR_DESKEW = false; # deskew sometimes messes up, so I do it manually
      PAPERLESS_FILENAME_FORMAT = "{{ owner_username }}/{{ created_year }}/{{ created_year }}-{{ created_month }}-{{ created_day }} {{ title }}";
      PAPERLESS_CONSUMER_RECURSIVE = true;
    };
    inherit consumptionDir;
  };

  services.nginx.virtualHosts.${fqdn} = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${builtins.toString config.services.paperless.port}";
      proxyWebsockets = true;
      extraConfig = ''
        # allow upload of large documents
        client_max_body_size 100M;
      '';
    };
  };

  services.postgresql = {
    enable = true;
    ensureUsers = [{
      name = "paperless";
      ensureDBOwnership = true;
    }];
    ensureDatabases = [ "paperless" ];
  };

  sops.secrets.paperless_password = { };

  systemd.tmpfiles.settings."10-paperless".${consumptionDir} = lib.mkForce { };

  # make the services not spam restart on failure...
  systemd.services = {
    paperless-consumer.serviceConfig.RestartSec = 2;
    paperless-scheduler.serviceConfig.RestartSec = 2;
    paperless-task-queue.serviceConfig.RestartSec = 2;
    paperless-web.serviceConfig.RestartSec = 2;
  };
}
