{ config, pkgs, flakeRoot, ... }:
let
  cfg = config.services.invidious;
  useFromUnstable = import (flakeRoot + /util/useFromUnstable.nix);
in
{
  # Use invidious from unstable branch
  imports = [
    (useFromUnstable {
      modules = [ "services/web-apps/invidious.nix" ];
      pkgs = [ "invidious" "http3-ytproxy" ];
    })
  ];

  services.invidious = {
    enable = true;
    package = pkgs.invidious.overrideAttrs (_old: {
      patches = [
        # support for private instances
        (pkgs.fetchpatch {
          url = "https://web.archive.org/web/20240103152302id_/https://patch-diff.githubusercontent.com/raw/iv-org/invidious/pull/4259.diff";
          hash = "sha256-PbaDlE1iRm2oAIl4s4cEyu0hhuVfDzX/W0u36bB0dCQ=";
          decode = "gunzip";
        })
        # chapters support
        # (pkgs.fetchpatch {
        #   url = "https://web.archive.org/web/20240107104557id_/https://patch-diff.githubusercontent.com/raw/iv-org/invidious/pull/4111.diff";
        #   hash = "sha256-72Hh7kuNhOBIZ9UVjQZBuD48BusUqsyAcEYoAy4DFW4=";
        #   decode = "gunzip";
        # })
        # comments fix
        (pkgs.fetchpatch {
          url = "https://web.archive.org/web/20240419162133id_/https://patch-diff.githubusercontent.com/raw/iv-org/invidious/pull/4576.patch";
          hash = "sha256-UbFdAuK204Qc0mQ6ZYGCCnFYszm5DrR0IfXzLjv53yA=";
          decode = "gunzip";
        })
      ];
    });
    domain = "invidious.${config.fugi.baseDomain}";
    nginx.enable = true;
    http3-ytproxy.enable = true;
    port = 8723;
    settings = {
      registration_enabled = false;
      private_instance = true;
      db.user = "invidious";
    };
  };

  services.nginx.virtualHosts.${cfg.domain}.enableACME = false;
}
