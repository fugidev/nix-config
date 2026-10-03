{ flakeRoot, ... }:
{
  services.nginx.virtualHosts."live.cowdoll.pet" = {
    locations."/" = {
      proxyPass = "http://localhost:8090";
      proxyWebsockets = true;
    };
  };

  containers.stream = {
    autoStart = true;
    config = {
      imports = [
        (flakeRoot + /modules/lix.nix)
      ];

      services.owncast = {
        enable = true;
        openFirewall = true;
        port = 8090;
        rtmp-port = 1936;
      };

      nixpkgs.overlays = [
        (final: prev: {
          owncast = prev.owncast.overrideAttrs rec {
            version = "0.3.0";
            src = prev.fetchFromGitHub {
              owner = "owncast";
              repo = "owncast";
              tag = "v${version}";
              hash = "sha256-Nfpd45pt4XKG8iAliqLIw3kzGDWs0qNeMTiEkctWoY0=";
            };
            vendorHash = "sha256-yl1jCJmTrW42/BpCsgxO3lTBat9HBMCXf0qnF0npT7Y=";
          };
        })
      ];

      system.stateVersion = "26.05";
    };
  };
}
