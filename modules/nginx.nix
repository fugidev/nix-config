{ config, lib, pkgs, ... }:
let
  domain = config.fugi.domain;
in
{
  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;

    virtualHosts = {
      _ = {
        forceSSL = true;
        useACMEHost = domain;
        default = true;
        locations."/".extraConfig = ''
          add_header Content-Type text/plain;
          return 200 'it works!';
        '';
      };
    };
  };

  # Add nginx to acme's group so that it can read the cert files
  users.users.nginx.extraGroups = [ "acme" ];

  # Open firewall for nginx
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # Setup acme
  security.acme = {
    acceptTerms = true;

    # wildcard cert
    certs.${domain} = {
      domain = domain;
      extraDomainNames = [ "*.${domain}" ];
      email = "admin@fugi.dev";
      dnsProvider = "desec";
      dnsPropagationCheck = true;
      credentialsFile = config.sops.secrets.desec-creds.path;
    };
  };

  sops.secrets.desec-creds.owner = "acme";
}
