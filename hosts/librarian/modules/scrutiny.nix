{ config, lib, machineConfig, ... }:
{
  services.scrutiny = {
    enable = true;
    settings = {
      web.listen.port = 9284;
    };
  };

  services.influxdb2.provision.organizations.scrutiny = {
    auths.scrutiny = {
      tokenFile = config.sops.secrets."influxdb/tokens/scrutiny".path;
      allAccess = true;
    };
  };

  users.users.scrutiny = {
    group = "scrutiny";
    home = "/var/lib/scrutiny";
    isSystemUser = true;
  };
  users.groups.scrutiny = { };

  systemd.services.scrutiny = {
    serviceConfig = {
      User = "scrutiny";
      Group = "scrutiny";
      DynamicUser = lib.mkForce false;
      EnvironmentFile = config.sops.secrets.scrutiny-env.path;
    };
    postStart = lib.mkForce "";
  };

  sops.secrets = {
    "influxdb/tokens/scrutiny".owner = "influxdb2";
    scrutiny-env.owner = "scrutiny";
  };

  services.nginx.virtualHosts."smart.${machineConfig.baseDomain}" = {
    locations."/".proxyPass = "http://[::1]:${toString config.services.scrutiny.settings.web.listen.port}";
  };
}
