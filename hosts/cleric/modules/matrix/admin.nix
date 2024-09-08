{ pkgs, machineConfig, ... }:
{
  services.nginx.virtualHosts."synapse-admin.${machineConfig.baseDomain}" = {
    root = pkgs.synapse-admin.override {
      baseUrl = "https://matrix.${machineConfig.baseDomain}";
    };
  };
}
