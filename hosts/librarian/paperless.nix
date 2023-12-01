{ config, ... }:
{
  services.paperless = {
    enable = true;
    passwordFile = config.sops.secrets.paperless_password.path;
    extraConfig = {
      PAPERLESS_DBHOST = "/run/postgresql";
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_ADMIN_USER = "fugi";
      PAPERLESS_FILENAME_FORMAT = "{created_year}/{created_year}-{created_month}-{created_day} {title}";
      PAPERLESS_OCR_DESKEW = false; # deskew sometimes messes up, so I do it manually
    };
  };

  services.nginx.virtualHosts."paperless.${config.networking.fqdn}" = {
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

  sops.secrets.paperless_password.owner = config.services.paperless.user;
}
