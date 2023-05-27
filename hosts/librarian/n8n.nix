{ config, lib, pkgs, ... }:
{
  services.n8n.enable = true;

  services.nginx.virtualHosts."n8n.${config.fugi.domain}" = {
    forceSSL = true;
    useACMEHost = config.fugi.domain;

    locations."/".proxyPass = "http://localhost:5678";
  };

  fugi.allowUnfree = [ "n8n" ];
}
