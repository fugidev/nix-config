{ config, pkgs, inputs, ... }:
let
  cfg = config.services.invidious;
  nixpkgs-unstable = inputs.nixpkgs;
in
{
  # Use invidious from unstable branch
  disabledModules = [ "services/web-apps/invidious.nix" ];
  imports = [ "${nixpkgs-unstable}/nixos/modules/services/web-apps/invidious.nix" ];
  nixpkgs.overlays = [
    (self: super: {
      inherit (nixpkgs-unstable.legacyPackages."x86_64-linux") invidious http3-ytproxy;
    })
  ];

  services.invidious = {
    enable = true;
    package = pkgs.invidious.overrideAttrs (_old: {
      patches = [
        # support for private instances
        (pkgs.fetchpatch {
          url = "https://web.archive.org/web/20240103152302if_/https://patch-diff.githubusercontent.com/raw/iv-org/invidious/pull/4259.diff";
          hash = "sha256-PbaDlE1iRm2oAIl4s4cEyu0hhuVfDzX/W0u36bB0dCQ=";
        })
        # chapters support
        # (pkgs.fetchpatch {
        #   url = "https://web.archive.org/web/20240107104557if_/https://patch-diff.githubusercontent.com/raw/iv-org/invidious/pull/4111.diff";
        #   hash = "sha256-72Hh7kuNhOBIZ9UVjQZBuD48BusUqsyAcEYoAy4DFW4=";
        # })
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
