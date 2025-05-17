{ config, machineConfig, ... }:
{
  services.kavita = {
    enable = true;
    tokenKeyFile = "/var/lib/kavita/secret";
  };

  users.groups."media".members = [ "kavita" ];

  systemd.services.kavita = {
    bindsTo = [ "data.mount" ];
    after = [ "data.mount" ];

    # mount media paths
    serviceConfig.BindReadOnlyPaths = [
      "/data/share/Comics:/data/comics"
      "/data/share/Manga:/data/manga"
    ];
  };

  services.nginx.virtualHosts."kavita.${machineConfig.baseDomain}" = {
    locations."/" = {
      proxyPass = "http://localhost:${toString config.services.kavita.settings.Port}";
      proxyWebsockets = true;
    };
  };
}
