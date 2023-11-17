{ config, lib, pkgs, ... }:
let
  downloadDir = "/data/share/Downloads/_aria2";
in
{
  services.nginx.virtualHosts."ariang.${config.networking.fqdn}" = {
    # ariang frontend
    root = "${pkgs.ariang}/share/ariang";

    # proxy aria2 rpc
    locations."/jsonrpc" = {
      proxyPass = "http://[::1]:${builtins.toString config.services.aria2.rpcListenPort}";
      proxyWebsockets = true;
    };
  };

  # aria2
  services.aria2 = {
    enable = true;
    inherit downloadDir;
  };

  users.groups."media".members = [ "aria2" ];

  systemd.services.aria2 = {
    preStart = lib.mkAfter /* sh */ ''
      ${pkgs.gnused}/bin/sed -i "s/aria2rpc/$(cat ${config.sops.secrets.aria2_secret.path})/" /var/lib/aria2/aria2.conf
    '';

    serviceConfig.RequiresMountsFor = "/data";
  };

  sops.secrets.aria2_secret.owner = "aria2";

  systemd.tmpfiles.rules = [
    # create downloads directory and set permissions
    "d ${downloadDir} 2775 fugi media - -"
    "a ${downloadDir} - - - - d:g::rwx"
  ];
}
