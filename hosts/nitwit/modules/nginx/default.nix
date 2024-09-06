{ machineConfig, ... }:
{
  services.nginx.virtualHosts.${machineConfig.baseDomain} = {
    locations = {
      "=/index.html".alias = ./index.html;
    };
  };
}
