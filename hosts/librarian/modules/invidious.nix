{ config, pkgs, util, machineConfig, ... }:
let
  cfg = config.services.invidious;
in
{
  # Use invidious from unstable branch
  imports = [
    (util.useFromUnstable {
      modules = [ "services/web-apps/invidious.nix" ];
      pkgs = [
        "invidious"
        "http3-ytproxy"
        "inv-sig-helper"
      ];
    })
  ];

  services.invidious = {
    enable = true;
    package = pkgs.invidious.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
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
      ];
    });
    domain = "invidious.${machineConfig.baseDomain}";
    nginx.enable = true;
    http3-ytproxy.enable = true;
    sig-helper.enable = true;
    port = 8723;
    settings = {
      registration_enabled = false;
      private_instance = true;
      db.user = "invidious";
    };
    extraSettingsFile = "/var/lib/invidious/extra-conf.yaml";
  };

  services.nginx.virtualHosts.${cfg.domain}.enableACME = false;
}
