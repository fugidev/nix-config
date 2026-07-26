{ pkgs, machineConfig, ... }:
{
  services.nginx.virtualHosts."phanpy.${machineConfig.baseDomain}" = {
    root = pkgs.phanpy;
  };
}

