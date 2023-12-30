{ config, ... }:
{
  services.nginx.virtualHosts.${config.fugi.baseDomain} = {
    locations = {
      "=/index.html".alias = ./index.html;
    };
  };
}
