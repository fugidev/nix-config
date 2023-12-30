{ config, ... }:
{
  services.thelounge = {
    enable = true;
    extraConfig = {
      reverseProxy = true;
      host = "localhost";
    };
  };

  services.nginx.virtualHosts."irc.${config.fugi.baseDomain}" = {
    locations."/" = {
      proxyPass = "http://localhost:${toString config.services.thelounge.port}";
      proxyWebsockets = true;
    };
  };
}
