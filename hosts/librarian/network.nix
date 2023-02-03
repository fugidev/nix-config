{ config, lib, pkgs, ... }:
{
  networking = {
    useDHCP = false;
    useNetworkd = true;

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
      address = [ "192.168.0.202/24" ];
      routes = [{
        routeConfig.Gateway = "192.168.0.1";
      }];

      networkConfig.IPv6PrivacyExtensions = "kernel";
      ipv6AcceptRAConfig.UseDNS = false; # ignore dns servers supplied by router
    };
  };
}
