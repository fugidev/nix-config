{ config, util, ... }:
{
  imports = [
    (util.useFromUnstable {
      pkgs = [ "jellyfin" "jellyfin-web" ];
    })
  ];

  services.jellyfin.enable = true;

  users.groups."media".members = [ "jellyfin" ];

  systemd.services.jellyfin = {
    bindsTo = [ "data.mount" ];
    after = [ "data.mount" ];

    # mount media paths
    serviceConfig.BindReadOnlyPaths = [
      "/data/share/Filme:/data/movies"
      "/data/share/Serien:/data/tvshows"
      "/data/share/Hörbücher:/data/audiobooks"
    ];
  };

  # auto discovery
  networking.firewall.allowedUDPPorts = [ 1900 7359 ];

  services.nginx.virtualHosts."jellyfin.${config.networking.fqdn}" = {
    extraConfig = ''
      # The default `client_max_body_size` is 1M, this might not be enough for some posters, etc.
      client_max_body_size 20M;

      # Disable buffering when the nginx proxy gets very resource heavy upon streaming
      proxy_buffering off;
    '';

    locations."/" = {
      proxyPass = "http://localhost:8096";
      proxyWebsockets = true;
    };
  };
}
