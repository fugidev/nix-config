{ config, lib, pkgs, ... }:
let
  inherit (config.networking) fqdn;
  IPv4 = config.fugi.staticIPv4.address;
  IPv6 = config.fugi.staticIPv6.address;
  adguardUser = "adguardhome";
in
{
  services.adguardhome = {
    enable = true;

    settings = {
      # for web interface
      http.address = "[::1]:3000";

      users = [{
        name = "admin";
        password = "ADGUARDPASS"; # placeholder
      }];

      dns = {
        # listen on local network
        bind_hosts = [ IPv4 IPv6 ];
        # use local resolver as upstream
        upstream_dns = [ "::1" ];
        bootstrap_dns = [ "::1" ];
        anonymize_client_ip = true;
      };

      querylog.interval = "6h";
      statistics.interval = "${toString (7*24)}h";

      filters = [
        {
          enabled = true;
          url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/multi.txt";
          name = "HaGeZi's Normal DNS Blocklist";
          id = 0;
        }
      ];

      filtering = {
        # applies to rewrites as well and the default (10s) is way too low
        blocked_response_ttl = 15 * 60;
        rewrites = [
          { domain = fqdn; answer = IPv4; }
          { domain = fqdn; answer = IPv6; }
          { domain = "*.${fqdn}"; answer = fqdn; }
        ];
      };
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
  services.nginx.virtualHosts."dns.${config.networking.fqdn}" = {
    locations."/".proxyPass = "http://${config.services.adguardhome.settings.http.address}";
  };
}
