{ config, pkgs, util, ... }:
{
  imports = util.dirPaths ./modules;

  home-manager.users.lyn.imports = util.dirPaths ./home;

  users.users.lyn.home = "/Users/lyn";

  system.primaryUser = "lyn";

  environment.systemPackages = with pkgs; [
    # install user applications to `/Applications/Nix Apps`
    (buildEnv {
      name = "user-applications";
      paths = config.users.users.lyn.packages;
      pathsToLink = [ "/Applications" ];
    })

    (writeScriptBin "reboot-nixos" ''
      echo fakepassword | sudo bless --mount /Volumes/NixOS --setBoot --nextonly --stdinpass && sudo shutdown -r now
    '')
  ];

  security.pam.services.sudo_local.touchIdAuth = true;

  nix.settings = {
    sandbox = true;
    experimental-features = "nix-command flakes";
  };

  system.stateVersion = 6;
}
