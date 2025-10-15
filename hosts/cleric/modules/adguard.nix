{
  config,
  lib,
  flakeRoot,
  machineConfig,
  ...
}:
let
  domain = "dns.${machineConfig.baseDomain}";
  DoTPort = 853;
  certDir = config.security.acme.certs.${domain}.directory;
in
{
  imports = [
    (flakeRoot + /modules/adguard.nix)
  ];

  services.adguardhome.settings = {
    querylog.enabled = false;
    filtering.rewrites = lib.mkForce [ ];

    tls = {
      enabled = true;
      server_name = domain;

      # DoH behind nginx
      force_https = false;
      port_https = 0;
      allow_unencrypted_doh = true;

      # DoT
      port_dns_over_tls = DoTPort;
      port_dns_over_quic = DoTPort;
      certificate_path = "${certDir}/fullchain.pem";
      private_key_path = "${certDir}/key.pem";
    };

    # also listen over wireguard
    dns.bind_hosts = [ "10.13.13.1" ];
  };

  security.acme.certs.${domain} = {
    group = "adguardhome";
    reloadServices = [ "adguardhome.service" ];

    inherit (config.security.acme.certs.${machineConfig.baseDomain})
      dnsProvider
      dnsPropagationCheck
      dnsResolver
      credentialFiles
      environmentFile
      ;
  };

  networking.firewall = {
    allowedUDPPorts = [ DoTPort ];
    allowedTCPPorts = [ DoTPort ];
    interfaces."wg0".allowedUDPPorts = [ 53 ];
  };
}
