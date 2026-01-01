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
    };

    extraConfig = ''
      rewrite ^/config.json$ /config.json break;
      rewrite ^/manifest.json$ /manifest.json break;

      rewrite ^/sw.js$ /sw.js break;
      rewrite ^/pdf.worker.min.js$ /pdf.worker.min.js break;

      rewrite ^/public/(.*)$ /public/$1 break;
      rewrite ^/assets/(.*)$ /assets/$1 break;

      rewrite ^(.+)$ /index.html break;
    '';
  };
}
