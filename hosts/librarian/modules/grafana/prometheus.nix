{ config, machineConfig, ... }:
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
      postgres = {
        enable = true;
        listenAddress = "localhost";
        runAsLocalSuperUser = true;
      };
    };

    scrapeConfigs = [
      {
        job_name = machineConfig.hostName;
        scrape_interval = "5m";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
        }];
      }
      {
        job_name = "${machineConfig.hostName}-smart";
        scrape_interval = "5m";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.smartctl.port}" ];
        }];
      }
      {
        job_name = "${machineConfig.hostName}-postgres";
        scrape_interval = "5m";
        static_configs = [{
          targets = [ "localhost:${toString config.services.prometheus.exporters.postgres.port}" ];
        }];
      }
      {
        job_name = "fugiweather";
        scrape_interval = "1m";
        scrape_timeout = "20s";
        static_configs = [{
          targets = [ "192.168.0.8:80" ];
        }];
      }
      {
        job_name = "cleric-synapse";
        scrape_interval = "5m";
        static_configs = [{
          targets = [ "10.13.13.1:8009" ];
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
