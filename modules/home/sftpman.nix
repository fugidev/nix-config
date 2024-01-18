{ lib, ... }:
{
  programs.sftpman = {
    enable = true;
    defaultSshKey = lib.mkDefault "/home/fugi/.ssh/id_ed25519";

    mounts = {
      nitwit = {
        host = "nitwit.fugi.dev";
        mountPoint = "/etc/nixos";
        user = "root";
        mountOptions = [
          "idmap=user"
        ];
      };
      librarian = {
        host = "librarian.fugi.dev";
        mountPoint = "/etc/nixos";
        user = "root";
        mountOptions = [
          "idmap=user"
        ];
      };
      quitte = {
        host = "quitte.ifsr.de";
        mountPoint = "/etc/nixos";
        user = "root";
        mountOptions = [
          "idmap=user"
        ];
      };
    };
  };
}
