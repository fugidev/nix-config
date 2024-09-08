{ config, pkgs, machineConfig, ... }:
let
  inherit (machineConfig) baseDomain;
  fqdn = "matrix.${baseDomain}";
  baseUrl = "https://${fqdn}";

  mkWellKnown = data: ''
    default_type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '${builtins.toJSON data}';
  '';
in
{
  sops.secrets = {
    "synapse/secrets".owner = "matrix-synapse";
    "synapse/signing-key".owner = "matrix-synapse";
  };

  services.matrix-synapse = {
    enable = true;
    configureRedisLocally = true;
    extraConfigFiles = [ config.sops.secrets."synapse/secrets".path ];

    settings = {
      server_name = baseDomain;
      public_baseurl = baseUrl;

      signing_key_path = config.sops.secrets."synapse/signing-key".path;

      listeners = [{
        port = 8008;
        bind_addresses = [ "::1" ];
        type = "http";
        tls = false;
        x_forwarded = true;
        resources = [{
          names = [ "client" "federation" ];
          compress = false;
        }];
      }];
    };
  };

  services.nginx.virtualHosts = {
    ${baseDomain}.locations = {
      # Delegation
      # https://matrix-org.github.io/synapse/latest/delegate.html
      "= /.well-known/matrix/server".extraConfig = mkWellKnown {
        "m.server" = "${fqdn}:443";
      };
      # Homeserver discovery
      # https://matrix-org.github.io/synapse/latest/setup/installation.html#client-well-known-uri
      "= /.well-known/matrix/client".extraConfig = mkWellKnown {
        "m.homeserver".base_url = baseUrl;
      };
    };
    ${fqdn}.locations = {
      # Forward to synapse
      "/".proxyPass = "http://[::1]:8008";
    };
  };

  services.postgresql = {
    enable = true;
    ensureUsers = [{
      name = "matrix-synapse";
    }];
  };

  systemd.services.matrix-synapse-pgsetup = {
    description = "Prepare Synapse postgres database";
    wantedBy = [ "multi-user.target" ];
    after = [ "networking.target" "postgresql.service" ];
    before = [ "matrix-synapse.service" ];
    serviceConfig.Type = "oneshot";

    path = [ pkgs.sudo config.services.postgresql.package ];

    # create database for synapse. will silently fail if it already exists
    script = ''
      sudo -u ${config.services.postgresql.superUser} psql <<SQL
        CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
          ENCODING 'UTF8'
          TEMPLATE template0
          LC_COLLATE = "C"
          LC_CTYPE = "C";
      SQL
    '';
  };
}
