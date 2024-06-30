{ config, lib, ... }:
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
    networks."40-eno1" = {
      name = "eno1";

      address = builtins.map
        ({ address, prefixLength }: "${address}/${toString prefixLength}")
        (lib.attrVals [ "staticIPv4" "staticIPv6" ] config.fugi);

      routes = [{
        routeConfig.Gateway = "192.168.0.1";
      }];

      networkConfig.IPv6PrivacyExtensions = "kernel";
      ipv6AcceptRAConfig.UseDNS = false; # ignore dns servers supplied by router
    };
    links."40-eno1" = {
      matchConfig = {
        MACAddress = "f8:ca:b8:3c:3c:62";
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
      networkConfig.Address = "10.13.13.7/24";
      routes = [
        { routeConfig = { Gateway = "10.13.13.1"; Destination = "10.13.13.0/24"; }; }
      ];
    };
  };

  # initrd network
  boot.initrd.systemd.network = {
    enable = true;
    networks."40-eno1" = config.systemd.network.networks."40-eno1";
    links."40-eno1" = config.systemd.network.links."40-eno1";
  };
}
