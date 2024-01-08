{ config, pkgs, ... }:
{
  services.nginx.virtualHosts."element.${config.fugi.baseDomain}" = {
    root = pkgs.element-web.override {
      conf = {
        default_server_name = config.fugi.baseDomain;
        default_theme = "dark";
        disable_custom_urls = true;
      };
    };
  };
}
