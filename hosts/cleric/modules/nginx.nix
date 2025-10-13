{ machineConfig, ... }:
{
  services.nginx.virtualHosts.${machineConfig.baseDomain} = {
    locations = {
      "/".root = "/srv/www";
    };
  };

  systemd.tmpfiles.settings."www" = {
    "/srv/www".d = {
      mode = "0770";
      user = "nginx";
      group = "nginx";
    };
  };

  services.borgmatic.settings.source_directories = [
    "/srv"
  ];
}
