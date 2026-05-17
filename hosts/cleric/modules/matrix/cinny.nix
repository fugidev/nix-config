{ pkgs, machineConfig, ... }:
let
  cinnyConfig = {
    allowCustomHomeservers = false;
    defaultHomeserver = 0;
    homeserverList = [ machineConfig.baseDomain ];
  };
in
{
  services.nginx.virtualHosts."cinny.${machineConfig.baseDomain}" = {
    root = pkgs.cinny.override {
      conf = cinnyConfig;
      cinny-unwrapped = pkgs.sable-unwrapped;
    };

    extraConfig = ''
      rewrite ^/config.json$ /config.json break;
      rewrite ^/manifest.json$ /manifest.json break;

      rewrite ^/sw.js$ /sw.js break;
      rewrite ^/pdf.worker.min.js$ /pdf.worker.min.js break;

      rewrite ^/public/(?<path>.*)$ /public/$path break;
      rewrite ^/assets/(?<path>.*)$ /assets/$path break;

      rewrite ^(.+)$ /index.html break;
    '';
  };
}
