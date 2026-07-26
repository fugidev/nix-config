{ pkgs, machineConfig, util, ... }:
let
  cinnyConfig = {
    allowCustomHomeservers = false;
    defaultHomeserver = 0;
    homeserverList = [ machineConfig.baseDomain ];
  };
in
{
  imports = [
    (util.useFromUnstable {
      pkgs = [ "sable" ];
    })
  ];

  services.nginx.virtualHosts."cinny.${machineConfig.baseDomain}" = {
    root = pkgs.sable.override {
      conf = cinnyConfig;
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
