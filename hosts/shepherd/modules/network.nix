{ config, lib, ... }:
{
  sops.secrets = {
    "wg-fugi/privkey".owner = config.users.users.systemd-network.name;
    "wg-fugi/psk".owner = config.users.users.systemd-network.name;
  };

  networking = {
    hostName = "shepherd";
    useDHCP = false;
    useNetworkd = true;

    # open wireguard port
    firewall.allowedUDPPorts = [ 51820 ];
  };

  # use unbound as local dns resolver
  services.resolved.enable = false;
  services.unbound = {
    enable = true;
    localControlSocketPath = "/run/unbound/unbound.ctl";
    settings = {
      server = {
        prefetch = true;
      };
    };
  };

  systemd.network = {
    # Ethernet
    networks."40-end0" = {
      name = "end0";

      # address = builtins.map
      #   ({ address, prefixLength }: "${address}/${toString prefixLength}")
      #   (lib.attrVals [ "staticIPv4" "staticIPv6" ] config.fugi);

      # routes = [{
      #   routeConfig.Gateway = "192.168.0.1";
      # }];

      networkConfig.DHCP = "ipv4"; # TODO remove
      networkConfig.IPv6PrivacyExtensions = "kernel";
      ipv6AcceptRAConfig.UseDNS = false; # ignore dns servers supplied by router
    };
    links."40-end0" = {
      matchConfig = {
        MACAddress = "e4:5f:01:06:00:49";
      };
      linkConfig = {
        NamePolicy = "kernel database onboard slot path";
        MACAddressPolicy = "persistent";
        WakeOnLan = "magic";
      };
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
      networkConfig.Address = "10.13.13.8/24";
      routes = [
        { routeConfig = { Gateway = "10.13.13.1"; Destination = "10.13.13.0/24"; }; }
      ];
    };
  };
}