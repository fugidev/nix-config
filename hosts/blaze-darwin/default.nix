{ config, pkgs, util, ... }:
{
  imports = util.dirPaths ./modules;

  home-manager.users.fugi.imports = util.dirPaths ./home;

  users.users.fugi.home = "/Users/fugi";

  system.primaryUser = "fugi";

  environment.systemPackages = with pkgs; [
    # install user applications to `/Applications/Nix Apps`
    (buildEnv {
      name = "user-applications";
      paths = config.users.users.fugi.packages;
      pathsToLink = [ "/Applications" ];
    })

    (writeScriptBin "reboot-nixos" ''
      echo fakepassword | sudo bless --mount /Volumes/NixOS --setBoot --nextonly --stdinpass && sudo shutdown -r now
    '')
  ];

  # set by lix installer
  ids.gids.nixbld = 30000;

  nix.settings = {
    sandbox = true;
    experimental-features = "nix-command flakes";
  };

  system.stateVersion = 6;
}
