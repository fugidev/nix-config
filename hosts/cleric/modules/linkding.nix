{ machineConfig, ... }:
{
  services.linkding.enable = true;

  services.nginx.virtualHosts."linkding.${machineConfig.baseDomain}" = {
    locations."/".proxyPass = "http://127.0.0.1:9090";
  };
}
