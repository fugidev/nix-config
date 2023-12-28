{ config, ... }:
{
  services.nginx.virtualHosts.${config.networking.fqdn} = {
    locations = {
      "=/index.html".alias = ./index.html;
    };
  };
}
