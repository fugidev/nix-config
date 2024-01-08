{ config, pkgs, ... }:
{
  services.nginx.virtualHosts."synapse-admin.${config.fugi.baseDomain}" = {
    root = pkgs.synapse-admin.override {
      baseUrl = "https://matrix.${config.fugi.baseDomain}";
    };
  };
}
