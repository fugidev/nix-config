{
  config,
  machineConfig,
  ...
}:
{
  services.immich = {
    enable = true;
  };

  services.nginx = {
    virtualHosts."media.${machineConfig.baseDomain}" = {
      locations."/" = {
        proxyPass = "http://localhost:${toString config.services.immich.port}";
        proxyWebsockets = true;
      };
    };
  };
}
