{ machineConfig, ... }:
let
  port = "19829";
in
{
  services.uptime-kuma = {
    enable = true;
    appriseSupport = true;
    settings.PORT = port;
  };

  services.nginx.virtualHosts."status.${machineConfig.baseDomain}" = {
    locations."/" = {
      proxyPass = "http://localhost:${port}";
      proxyWebsockets = true;
    };
  };
}
