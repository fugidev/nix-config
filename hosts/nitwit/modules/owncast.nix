{ config, ... }:
let
  cfg = config.services.owncast;
in
{
  services.owncast = {
    enable = true;
    openFirewall = true; # only opens rtmp port
    port = 8298;
  };

  services.nginx.virtualHosts."efg.${config.fugi.baseDomain}" = {
    basicAuthFile = config.sops.secrets."owncast-auth".path;
    locations = {
      "/" = {
        proxyPass = "http://localhost:${toString cfg.port}";
        proxyWebsockets = true;
      };
      "/admin" = {
        proxyPass = "http://localhost:${toString cfg.port}";
        proxyWebsockets = true;
        extraConfig = ''
          auth_basic off;
        '';
      };
    };
  };

  sops.secrets."owncast-auth".owner = "nginx";
}
