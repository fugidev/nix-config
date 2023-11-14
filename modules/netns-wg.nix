# Example adding a service to the network namespace:
#
# systemd.services."example-service" = {
#   bindsTo = [ "netns-<netns-name>.service" ];
#   serviceConfig.NetworkNamespacePath = "/var/run/netns/<netns-name>";
# };

{ config, lib, pkgs, ... }:
let
  inherit (builtins) map;
  inherit (lib) mkIf mkEnableOption mkOption types concatMapAttrs;
  inherit (lib.attrsets) mergeAttrsList;

  cfg = config.fugi.netns-wg;

  nsOpts = {
    options = {
      interfaceName = mkOption {
        type = types.str;
        description = "Name of the wireguard interface.";
      };
      ip = mkOption {
        type = types.str;
        description = "Wireguard-internal IP.";
        example = "10.13.13.2/32";
      };
      privateKeyFile = mkOption {
        type = types.str;
      };
      server = {
        endpoint = mkOption {
          type = types.str;
          example = "203.0.113.18:51820";
        };
        publicKey = mkOption {
          type = types.str;
        };
        allowedIPs = mkOption {
          type = types.listOf types.str;
          description = "IP ranges that should be routed through the wireguard interface.";
          default = [ "0.0.0.0/0" ];
        };
      };
      ports = mkOption {
        type = types.listOf (types.submodule {
          options = {
            host = mkOption {
              type = types.port;
            };
            netns = mkOption {
              type = types.port;
            };
          };
        });
        description = "Ports to expose from the network namespace to the host.";
        default = [ ];
        example = [
          { host = 8081; netns = 8081; }
          { host = 8082; netns = 80; }
        ];
      };
      nameserver = mkOption {
        type = types.str;
        example = "10.13.13.1";
      };
    };
  };
in
{
  options.fugi.netns-wg = {
    enable = mkEnableOption "netns-wg";

    namespaces = mkOption {
      type = types.attrsOf (types.submodule nsOpts);
      default = { };
    };
  };

  config = mkIf cfg.enable {
    # Create Wireguard interfaces
    networking.wireguard.interfaces = concatMapAttrs
      (nsName: nsCfg: {
        ${nsCfg.interfaceName} = {
          inherit (nsCfg) privateKeyFile;
          generatePrivateKeyFile = false;

          ips = [ nsCfg.ip ];
          peers = [ nsCfg.server ];

          # Move interface to network namespace
          interfaceNamespace = nsName;
        };
      })
      cfg.namespaces;

    systemd.services = concatMapAttrs
      (nsName: nsCfg: ({
        # Create namespace
        "netns-${nsName}" = {
          description = "${nsName} network namespace";
          before = [ "network.target" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            # ExecStart = "${pkgs.iproute2}/bin/ip netns add ${nsName}";
            ExecStop = "${pkgs.iproute2}/bin/ip netns del ${nsName}";
          };
          script = ''
            ${pkgs.iproute2}/bin/ip netns add ${nsName}
            ${pkgs.iproute2}/bin/ip netns exec ${nsName} ${pkgs.iproute2}/bin/ip link set dev lo up
          '';
        };
        # Start Wireguard after namespace is created
        "wireguard-${nsCfg.interfaceName}" = {
          requires = [ "netns-${nsName}.service" ];
          after = [ "netns-${nsName}.service" ];
        };
      } // mergeAttrsList (map
        (port: {
          # Map ports to host
          "netns-${nsName}-ports-${toString port.host}:${toString port.netns}" = {
            description = "${nsName} network namespace port mapping";
            requires = [ "netns-${nsName}.service" ];
            after = [ "netns-${nsName}.service" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              Restart = "on-failure";
              TimeoutStopSec = 300;
            };
            script = ''
              ${pkgs.socat}/bin/socat tcp-listen:${toString port.host},fork,reuseaddr \
                exec:'${pkgs.iproute2}/bin/ip netns exec ${nsName} ${pkgs.socat}/bin/socat STDIO "tcp-connect:127.0.0.1:${toString port.netns}"',nofork
            '';
          };
        })
        nsCfg.ports
      )))
      cfg.namespaces;

    environment.etc = concatMapAttrs
      (nsName: nsCfg: {
        "netns/${nsName}/resolv.conf".text = ''
          nameserver ${nsCfg.nameserver}
        '';
      })
      cfg.namespaces;
  };
}
