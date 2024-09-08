{ pkgs, machineConfig, ... }:
{
  services.nginx.virtualHosts."element.${machineConfig.baseDomain}" = {
    root = pkgs.element-web.override {
      conf = {
        default_server_name = machineConfig.baseDomain;
        default_theme = "dark";
        disable_custom_urls = true;
      };
    };
  };
}
