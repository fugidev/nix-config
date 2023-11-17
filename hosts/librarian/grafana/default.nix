{ config, ... }:
let
  domain = "grafana.${config.networking.fqdn}";
  http_port = 8126;
in
{
  imports = [
    ./prometheus.nix
  ];

  services.grafana = {
    enable = true;

    settings = {
      server = {
        inherit domain http_port;
      };
      security = {
        admin_user = "fugi";
        admin_password = "$__file{${config.sops.secrets."grafana/admin_pass".path}}";
        secret_key = "$__file{${config.sops.secrets."grafana/secret_key".path}}";
        disable_gravatar = true;
      };
      analytics = {
        reporting_enabled = false;
        feedback_links_enabled = false;
      };
    };

    provision = {
      datasources.settings.datasources = [{
        name = "Prometheus";
        type = "prometheus";
        isDefault = true;
        url = "http://localhost:${toString config.services.prometheus.port}";
      }];
    };
  };

  services.nginx.virtualHosts.${domain} = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString http_port}";
      proxyWebsockets = true;
    };
  };

  sops.secrets =
    let user = config.systemd.services."grafana".serviceConfig.User;
    in {
      "grafana/admin_pass".owner = user;
      "grafana/secret_key".owner = user;
    };
}
