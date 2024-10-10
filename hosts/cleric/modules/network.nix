{ config, machineConfig, ... }:
{
  networking = {
    inherit (machineConfig) hostName;
    useDHCP = false;
    useNetworkd = true;
  };

  systemd.network = {
    # Ethernet
    networks."40-ens3" = {
      name = "ens3";

      address = [
        machineConfig.IPv4.cidr
        machineConfig.IPv6.cidr
      ];

      routes = [
        { routeConfig.Gateway = "152.53.100.1"; }
        { routeConfig.Gateway = "fe80::1"; }
      ];

      networkConfig.IPv6PrivacyExtensions = "kernel";
      ipv6AcceptRAConfig.UseDNS = false; # ignore dns servers supplied by router
    };
    links."40-ens3" = {
      matchConfig = {
        MACAddress = "f8:ca:b8:3c:3c:62";
      };
      linkConfig = {
        NamePolicy = "kernel database onboard slot path";
        MACAddressPolicy = "persistent";
      };
    };
  };

  # initrd network
  boot.initrd.systemd.network = {
    enable = true;
    networks."40-ens3" = config.systemd.network.networks."40-ens3";
    links."40-ens3" = config.systemd.network.links."40-ens3";
  };
}
