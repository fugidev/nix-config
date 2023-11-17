{ config, lib, pkgs, ... }:
let
  sharePath = "/data/share";
in
{
  sops.secrets.smbpass_fugi = { };

  services.samba = {
    enable = true;

    # not needed
    enableNmbd = false;
    enableWinbindd = false;

    securityType = "user";

    extraConfig = ''
      smb ports = 445
      min protocol = SMB3_00

      hosts allow = 192.168.0. 127.0.0.1 ::1
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user

      disable spoolss = yes
      disable netbios = yes

      # should improve speed
      use sendfile = yes

      # hide bloat
      veto files = /._*/.apdisk/.AppleDouble/.DS_Store/.TemporaryItems/.Trashes/desktop.ini/ehthumbs.db/Network Trash Folder/Temporary Items/Thumbs.db/
      delete veto files = yes

      # recommended config for improved apple support
      vfs objects = fruit streams_xattr
      fruit:metadata = stream
      fruit:model = MacSamba
      fruit:posix_rename = yes
      fruit:veto_appledouble = no
      fruit:nfs_aces = no
      fruit:wipe_intentionally_left_blank_rfork = yes
      fruit:delete_empty_adfiles = yes
    '';

    shares = {
      librarian = {
        path = sharePath;
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = "fugi";
        "create mask" = "0644";
        "directory mask" = "0755";
        "server smb encrypt" = "desired";
      };
    };
  };

  # set smb password on activation
  system.activationScripts.smbpasswd = {
    deps = [ "users" ];
    text =
      let
        sed = lib.getExe pkgs.gnused;
        password_file = config.sops.secrets.smbpass_fugi.path;
        smbpasswd = "${config.services.samba.package}/bin/smbpasswd";
      in
      ''
        # hack because smbpasswd needs to read the password TWICE from stdin...
        ${sed} '$s/$/\n/' ${password_file}{,} | ${smbpasswd} -s -a fugi
      '';
  };

  # SMB over TCP
  networking.firewall.allowedTCPPorts = [ 445 ];

  # require /data mount
  systemd.services.samba-smbd = {
    bindsTo = [ "data.mount" ];
    after = [ "data.mount" ];
  };

  systemd.tmpfiles.rules = [
    "d ${sharePath} - fugi users - -"
    "d ${sharePath}/Downloads - fugi users - -"
    "d ${sharePath}/Filme 2775 fugi media - -"
    "a ${sharePath}/Filme - - - - d:g::rwx"
    "d ${sharePath}/Serien 2775 fugi media - -"
    "a ${sharePath}/Serien - - - - d:g::rwx"
  ];
}
