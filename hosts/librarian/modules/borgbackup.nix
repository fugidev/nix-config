{ config, lib, ... }:
let
  repoBasePath = "/data/borgbackup/";
  mkRepoService = name: cfg:
    lib.nameValuePair "borgbackup-repo-${name}" {
      bindsTo = [ "data.mount" ];
      after = [ "data.mount" ];
    };
in
{
  services.borgbackup.repos = {
    magmacube = {
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP6Xm07dMgZm9cfXIHNdXxyVHAO4qifXW+roLCGf+bO0 root@magmacube"
      ];
      path = "${repoBasePath}/magmacube";
    };
  };

  systemd.services = lib.mapAttrs' mkRepoService config.services.borgbackup.repos;
}
