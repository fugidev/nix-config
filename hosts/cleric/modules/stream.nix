{ pkgs, flakeRoot, ... }:
{
  services.nginx.virtualHosts."live.cowdoll.pet" = {
    locations."/" = {
      proxyPass = "http://localhost:8090";
      proxyWebsockets = true;
    };
  };

  networking.firewall.allowedTCPPorts = [ 1936 ];

  containers.stream = {
    autoStart = true;
    config = {
      imports = [
        (flakeRoot + /modules/lix.nix)
      ];

      services.owncast = {
        enable = true;
        port = 8090;
        rtmp-port = 1936;
      };

      nixpkgs.overlays = [
        (final: prev: {
          owncast = pkgs.owncast-unstable;
        })
      ];

      system.stateVersion = "26.05";
    };
  };
}
