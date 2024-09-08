{ config, machineConfig, ... }:
{
  services.thelounge = {
    enable = true;
    extraConfig = {
      reverseProxy = true;
      host = "localhost";
    };
  };

  services.nginx.virtualHosts."irc.${machineConfig.baseDomain}" = {
    locations."/" = {
      proxyPass = "http://localhost:${toString config.services.thelounge.port}";
      proxyWebsockets = true;
    };
  };
}
