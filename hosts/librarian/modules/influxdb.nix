{ config, machineConfig, ... }:
{
  services.influxdb2 = {
    enable = true;
    provision = {
      enable = true;
      initialSetup = {
        organization = "main";
        bucket = "primary";
        passwordFile = config.sops.secrets."influxdb/pw".path;
        tokenFile = config.sops.secrets."influxdb/tokens/admin".path;
      };
    };
  };

  sops.secrets = {
    "influxdb/pw".owner = "influxdb2";
    "influxdb/tokens/admin".owner = "influxdb2";
  };

  services.nginx.virtualHosts."influxdb.${machineConfig.baseDomain}" = {
    locations."/".proxyPass = "http://localhost:8086";
  };
}
