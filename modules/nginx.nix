{ config, lib, ... }:
let
  inherit (config.networking) domain;
  fqdn = config.fugi.baseDomain;
in
{
  # set default options for virtualHosts
  options = with lib; {
    services.nginx.virtualHosts = mkOption {
      type = types.attrsOf (types.submodule {
        forceSSL = mkDefault true;
        useACMEHost = mkDefault fqdn;
      });
    };
  };

  config = {
    services.nginx = {
      enable = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedGzipSettings = true;

      virtualHosts = {
        _ = {
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
      defaults.email = "admin@${domain}";

      # wildcard cert
      certs.${fqdn} = {
        domain = fqdn;
        extraDomainNames = [ "*.${fqdn}" ];
        dnsProvider = "desec";
        dnsPropagationCheck = true;
        credentialFiles = {
          DESEC_TOKEN_FILE = config.sops.secrets.desec-token.path;
        };
        environmentFile = builtins.toFile "acme-envfile" ''
          DESEC_PROPAGATION_TIMEOUT=120
        '';
      };
    };

    sops.secrets.desec-token = { };
  };
}
