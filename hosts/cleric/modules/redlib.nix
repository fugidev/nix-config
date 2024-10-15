{ config, util, machineConfig, ... }:
let
  cfg = config.services.redlib;
in
{
  # Use redlib from unstable branch
  imports = [
    (util.useFromUnstable {
      modules = [ "services/misc/redlib.nix" ];
      pkgs = [ "redlib" ];
    })
  ];
  disabledModules = [ "services/misc/libreddit.nix" ];

  services.redlib = {
    enable = true;
    address = "127.0.0.1";
    port = 8490;
  };

  services.nginx.virtualHosts."libreddit.${machineConfig.baseDomain}" = {
    locations."/".proxyPass = "http://${cfg.address}:${toString cfg.port}";
  };
}
