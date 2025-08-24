{
  config,
  machineConfig,
  ...
}:
{
  services.immich = {
    enable = true;
  };

  services.nginx = {
    virtualHosts."media.${machineConfig.baseDomain}" = {
      locations."/" = {
        proxyPass = "http://localhost:${toString config.services.immich.port}";
        proxyWebsockets = true;
        extraConfig = ''
          # allow large file uploads
          client_max_body_size 50000M;
          # set timeout
          proxy_read_timeout 600s;
          proxy_send_timeout 600s;
          send_timeout 600s;
        '';
      };
    };
  };
}
