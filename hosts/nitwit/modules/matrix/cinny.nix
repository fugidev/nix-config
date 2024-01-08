{ config, pkgs, ... }:
let
  cinnyConfig = {
    allowCustomHomeservers = false;
    defaultHomeserver = 0;
    homeserverList = [ config.fugi.baseDomain ];
  };
in
{
  services.nginx.virtualHosts."cinny.${config.fugi.baseDomain}" = {
    # Workaround because cinny fails to build on nitwit for some reason
    # https://github.com/NixOS/nixpkgs/pull/267754
    root = pkgs.cinny;
    locations."=/config.json".extraConfig = ''
      default_type application/json;
      return 200 '${builtins.toJSON cinnyConfig}';
    '';

    # This is how it's supposed to be:
    # root = pkgs.cinny.override {
    #   conf = cinnyConfig
    # };
  };
}
