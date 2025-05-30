{ config, ... }:
{
  services.n8n.enable = true;

  services.nginx.virtualHosts."n8n.${config.networking.fqdn}" = {
    locations."/" = {
      proxyPass = "http://localhost:5678";
      proxyWebsockets = true;
    };
  };

  fugi.allowUnfree = [ "n8n" ];
}
