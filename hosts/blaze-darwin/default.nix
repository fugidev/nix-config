{ config, pkgs, util, ... }:
{
  home-manager.users.fugi.imports = util.dirPaths ./home;

  users.users.fugi.home = "/Users/fugi";

  environment.systemPackages = with pkgs; [
    # install user applications to `/Applications/Nix Apps`
    (buildEnv {
      name = "user-applications";
      paths = config.users.users.fugi.packages;
      pathsToLink = "/Applications";
    })
  ];

  # set by lix installer
  ids.gids.nixbld = 30000;

  system.stateVersion = 6;
}
