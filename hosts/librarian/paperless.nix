{ config, lib, pkgs, ... }:
{
  services.paperless = {
    enable = true;
    passwordFile = config.sops.secrets.paperless_password.path;
    extraConfig = {
      PAPERLESS_DBHOST = "/run/postgresql";
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_ADMIN_USER = "fugi";
    };
  };

  services.nginx.virtualHosts."paperless.${config.fugi.domain}" = {
    forceSSL = true;
    useACMEHost = config.fugi.domain;

    locations."/" = {
      proxyPass = "http://127.0.0.1:${builtins.toString config.services.paperless.port}";
      proxyWebsockets = true;
    };
  };

  services.postgresql = {
    enable = true;
    ensureUsers = [{
      name = "paperless";
      ensurePermissions = {
        "DATABASE paperless" = "ALL PRIVILEGES";
      };
    }];
    ensureDatabases = [ "paperless" ];
  };

  sops.secrets.paperless_password.owner = config.services.paperless.user;
}
