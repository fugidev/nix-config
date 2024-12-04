{ config, ... }:
let
  sharePath = "/data/share";
in
{
  services.samba = {
    settings = {
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

  systemd.tmpfiles.rules = [
    "d ${sharePath} - fugi users - -"
    "d ${sharePath}/Downloads - fugi users - -"
    "d ${sharePath}/Filme 2775 fugi media - -"
    "a ${sharePath}/Filme - - - - d:g::rwx"
    "d ${sharePath}/Serien 2775 fugi media - -"
    "a ${sharePath}/Serien - - - - d:g::rwx"
  ];

  sops.secrets.smbpass_fugi = { };

  fugi.sambaCreds.fugi = config.sops.secrets.smbpass_fugi.path;
}
