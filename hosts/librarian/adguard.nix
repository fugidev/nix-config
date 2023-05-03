{ config, lib, pkgs, ... }:
let
  adguardUser = "adguardhome";
in
{
  services.adguardhome = {
    enable = true;

    settings = {
      bind_host = "::1"; # for web interface

      users = [{
        name = "admin";
        password = "ADGUARDPASS"; # placeholder
      }];

      dns = rec {
        # only listen on local network, as 0.0.0.0 would conflict with systemd-resolved
        bind_hosts = [ config.fugi.staticIPv4.address ];
        # use systemd-resolved as upstream
        upstream_dns = [ "127.0.0.53" ];
        bootstrap_dns = upstream_dns;
      };

      filters = [
        {
          enabled = true;
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
          name = "AdGuard DNS filter";
          id = 0;
        }
        {
          enabled = true;
          url = "https://blocklistproject.github.io/Lists/adguard/ads-ags.txt";
          name = "Ads";
          id = 1;
        }
        {
          enabled = true;
          url = "https://blocklistproject.github.io/Lists/adguard/tracking-ags.txt";
          name = "Tracking";
          id = 2;
        }
      ];
    };
  };

  # add user, needed to access the secret
  users.users.${adguardUser} = {
    isSystemUser = true;
    group = adguardUser;
  };
  users.groups.${adguardUser} = { };

  sops.secrets.adguard_pass = {
    owner = adguardUser;
    restartUnits = [ "adguardhome.service" ];
  };

  # insert password before service starts
  systemd.services.adguardhome = {
    preStart = lib.mkAfter /* sh */ ''
      HASH=$(cat ${config.sops.secrets.adguard_pass.path} | ${pkgs.apacheHttpd}/bin/htpasswd -niB "" | cut -c 2-)
      ${pkgs.gnused}/bin/sed -i "s,ADGUARDPASS,$HASH," "$STATE_DIRECTORY/AdGuardHome.yaml"
    '';
    serviceConfig.User = adguardUser;
  };

  # open firewall
  networking.firewall.allowedUDPPorts = [ 53 ];

  # nginx proxy
  services.nginx.virtualHosts."dns.${config.fugi.domain}" = {
    forceSSL = true;
    useACMEHost = config.fugi.domain;

    locations."/".proxyPass = "http://[::1]:${builtins.toString config.services.adguardhome.settings.bind_port}";
  };
}
