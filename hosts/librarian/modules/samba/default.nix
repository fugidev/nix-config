{ config, lib, pkgs, util, ... }:
let
  inherit (lib) types mkOption;
in
{
  imports = (util.dirPaths ./shares);

  options.fugi.sambaCreds = mkOption {
    type = types.attrsOf (types.path);
    default = { };
  };

  config = {
    services.samba = {
      enable = true;

      # not needed
      nmbd.enable = false;
      winbindd.enable = false;

      settings.global = {
        "smb ports" = "445";
        "min protocol" = "SMB3_00";

        "guest account" = "nobody";
        "map to guest" = "bad user";

        "disable spoolss" = "yes";
        "disable netbios" = "yes";

        # should improve speed
        "use sendfile" = "yes";

        # hide bloat
        "veto files" = "/._*/.apdisk/.AppleDouble/.DS_Store/.TemporaryItems/.Trashes/desktop.ini/ehthumbs.db/Network Trash Folder/Temporary Items/Thumbs.db/";
        "delete veto files" = "yes";

        # recommended config for improved apple support
        "vfs objects" = "fruit streams_xattr";
        "fruit:metadata" = "stream";
        "fruit:model" = "MacSamba";
        "fruit:posix_rename" = "yes";
        "fruit:veto_appledouble" = "no";
        "fruit:nfs_aces" = "no";
        "fruit:wipe_intentionally_left_blank_rfork" = "yes";
        "fruit:delete_empty_adfiles" = "yes";
      };
    };

    # SMB over TCP
    networking.firewall.allowedTCPPorts = [ 445 ];

    # require /data mount
    systemd.services.samba-smbd = {
      bindsTo = [ "data.mount" ];
      after = [ "data.mount" ];
    };

    # set smb password on activation
    system.activationScripts.sambaCreds = {
      deps = [ "users" ];
      text =
        let
          sed = lib.getExe pkgs.gnused;
          smbpasswd = lib.getExe' config.services.samba.package "smbpasswd";
        in
        lib.concatLines (lib.mapAttrsToList
          # hack because smbpasswd needs to read the password TWICE from stdin...
          # note: set passwords will not be cleared
          (user: password_file: ''
            ${sed} '$s/$/\n/' ${password_file}{,} | ${smbpasswd} -s -a ${user}
          '')
          config.fugi.sambaCreds
        );
    };
  };
}
