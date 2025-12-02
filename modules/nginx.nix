{ config, lib, machineConfig, ... }:
let
  inherit (machineConfig) domain baseDomain;

  isOnBaseDomain = lib.hasSuffix baseDomain;
in
{
  # set default options for virtualHosts
  options = with lib; {
    services.nginx.virtualHosts = mkOption {
      type = types.attrsOf (types.submodule
        ({ name, ... }: {
          forceSSL = mkDefault true;
          useACMEHost = mkIf (isOnBaseDomain name) (mkDefault baseDomain);
          enableACME = mkDefault (! isOnBaseDomain name);
          # split up nginx access logs per vhost
          extraConfig = ''
            access_log /var/log/nginx/${name}_access.log;
            error_log /var/log/nginx/${name}_error.log;
          '';
        })
      );
    };
  };

  config = {
    services.nginx = {
      enable = true;
      enableReload = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedGzipSettings = true;
      recommendedBrotliSettings = true;

      virtualHosts = {
        _ = {
          default = true;
          enableACME = false;
          useACMEHost = baseDomain;
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
      certs.${baseDomain} = {
        domain = baseDomain;
        extraDomainNames = [ "*.${baseDomain}" ];
        dnsProvider = "desec";
        dnsPropagationCheck = true;
        dnsResolver = "ns1.desec.io:53";
        credentialFiles = {
          DESEC_TOKEN_FILE = config.sops.secrets.desec-token.path;
        };
        environmentFile = builtins.toFile "acme-envfile" ''
          DESEC_PROPAGATION_TIMEOUT=120
        '';
        reloadServices = [ "nginx.service" ];
      };
    };

    sops.secrets.desec-token = { };
  };
}
