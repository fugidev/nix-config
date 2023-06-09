{ config, lib, pkgs, ... }:
{
  sops.secrets = {
    "wg-fugi/privkey".owner = config.users.users.systemd-network.name;
    "wg-fugi/psk".owner = config.users.users.systemd-network.name;
  };

  networking = {
    hostName = "librarian";

    useDHCP = false;
    useNetworkd = true;

    # open wireguard port
    firewall.allowedUDPPorts = [ 51820 ];

    nameservers = [
      "9.9.9.9#dns.quad9.net"
      "149.112.112.112#dns.quad9.net"
      "2620:fe::fe#dns.quad9.net"
      "2620:fe::9#dns.quad9.net"
    ];
  };

  services.resolved = {
    enable = true;
    dnssec = "true";
    extraConfig = ''
      DNSOverTLS=yes
    '';
  };

  systemd.network = {
    networks."40-eno1" = {
      name = "eno1";

      address = with config.fugi.staticIPv4;
        [ "${address}/${toString prefixLength}" ];

      routes = [{
        routeConfig.Gateway = "192.168.0.1";
      }];

      networkConfig.IPv6PrivacyExtensions = "kernel";
      ipv6AcceptRAConfig.UseDNS = false; # ignore dns servers supplied by router
    };

    # Wireguard
    netdevs."40-wg-fugi" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-fugi";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."wg-fugi/privkey".path;
      };
      wireguardPeers = [{
        wireguardPeerConfig = {
          PublicKey = "lJwLzQYJ2+DRO8E4nNeVxMLR4mGQg5Fjui6TPxzEbzA=";
          PresharedKeyFile = config.sops.secrets."wg-fugi/psk".path;
          Endpoint = "fugi.dev:51820";
          AllowedIPs = [ "10.13.13.0/24" ];
          PersistentKeepalive = 25;
        };
      }];
    };
    networks."40-wg-fugi" = {
      matchConfig.Name = "wg-fugi";
      networkConfig.Address = "10.13.13.7/24";
      routes = [
        { routeConfig = { Gateway = "10.13.13.1"; Destination = "10.13.13.0/24"; }; }
      ];
    };
  };
}
