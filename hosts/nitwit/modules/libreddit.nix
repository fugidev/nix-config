{ config, pkgs, flakeRoot, ... }:
let
  cfg = config.services.libreddit;
  useFromUnstable = import (flakeRoot + /util/useFromUnstable.nix);
in
{
  # Use libreddit/redlib from unstable branch
  imports = [
    (useFromUnstable {
      modules = [ "services/misc/libreddit.nix" ];
      pkgs = [ "redlib" ];
    })
  ];

  services.libreddit = {
    enable = true;
    package = pkgs.redlib;
    address = "127.0.0.1";
    port = 8490;
  };

  services.nginx.virtualHosts."libreddit.${config.fugi.baseDomain}" = {
    locations."/".proxyPass = "http://${cfg.address}:${toString cfg.port}";
  };
}
