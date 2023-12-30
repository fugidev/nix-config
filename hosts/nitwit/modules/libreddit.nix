{ config, ... }:
let
  cfg = config.services.libreddit;
in
{
  services.libreddit = {
    enable = true;
    address = "127.0.0.1";
    port = 8490;
  };

  services.nginx.virtualHosts."libreddit.${config.fugi.baseDomain}" = {
    locations."/".proxyPass = "http://${cfg.address}:${toString cfg.port}";
  };
}
