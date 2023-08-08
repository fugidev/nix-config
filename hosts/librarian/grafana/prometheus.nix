{ config, lib, pkgs, ... }:
{
  services.prometheus = {
    enable = true;
    retentionTime = "30d";

    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
      };
      smartctl = {
        enable = true;
      };
    };

    scrapeConfigs = [
      {
        job_name = config.networking.hostName;
        scrape_interval = "5m";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
        }];
      }
      {
        job_name = "${config.networking.hostName}-smart";
        scrape_interval = "5m";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.smartctl.port}" ];
        }];
      }
      {
        job_name = "fugiweather";
        scrape_interval = "1m";
        scrape_timeout = "20s";
        metrics_path = "/metrics";
        scheme = "http";
        static_configs = [{
          targets = [ "192.168.0.8:80" ];
        }];
      }
    ];
  };

  services.nginx.virtualHosts."prometheus.${config.networking.fqdn}" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.prometheus.port}";
      proxyWebsockets = true;
      basicAuthFile = config.sops.secrets."prometheus/basic-auth".path;
    };
  };

  sops.secrets."prometheus/basic-auth".owner = config.systemd.services."nginx".serviceConfig.User;
}
