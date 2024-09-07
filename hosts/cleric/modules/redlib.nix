{ config, flakeRoot, machineConfig, ... }:
let
  cfg = config.services.redlib;
  useFromUnstable = import (flakeRoot + /util/useFromUnstable.nix);
in
{
  # Use redlib from unstable branch
  imports = [
    (useFromUnstable {
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
