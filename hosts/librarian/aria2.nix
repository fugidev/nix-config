{ config, lib, pkgs, ... }:
{
  services.nginx.virtualHosts."ariang.${config.networking.fqdn}" = {
    # ariang frontend
    root = pkgs.callPackage ../../pkgs/ariang { };

    # proxy aria2 rpc
    locations."/jsonrpc" = {
      proxyPass = "http://[::1]:${builtins.toString config.services.aria2.rpcListenPort}";
      proxyWebsockets = true;
    };
  };

  # aria2
  services.aria2 = {
    enable = true;
    downloadDir = "/data/share/Downloads/_aria2";
  };

  systemd.services.aria2 = {
    preStart = lib.mkAfter /* sh */ ''
      ${pkgs.gnused}/bin/sed -i "s/aria2rpc/$(cat ${config.sops.secrets.aria2_secret.path})/" /var/lib/aria2/aria2.conf
    '';

    serviceConfig.RequiresMountsFor = "/data";
  };

  sops.secrets.aria2_secret.owner = "aria2";
}
