{ config, lib, machineConfig, ... }:
{
  options = {
    fugi.dhcp = {
      interface = lib.mkOption {
        type = lib.types.str;
      };
      IPv4Pool = lib.mkOption {
        type = lib.types.str;
      };
    };
  };

  config = {
    services.kea = {
      dhcp4 = {
        enable = true;
        settings = {
          valid-lifetime = 4*24*60*60; # 4d
          # valid-lifetime = 10*24*60*60; # 10d
          calculate-tee-times = true;
          interfaces-config.interfaces = [ config.fugi.dhcp.interface ];
          lease-database = {
            name = "/var/lib/kea/dhcp4.leases";
            type = "memfile";
          };
          subnet4 = [{
            subnet = "192.168.0.0/24";
            pools = [{
              pool = config.fugi.dhcp.IPv4Pool;
            }];
            option-data = [
              {
                name = "routers";
                data = "192.168.0.1";
              }
              {
                name = "domain-name";
                data = "fritz.box";
              }
              {
                name = "broadcast-address";
                data = "192.168.0.255";
              }
              {
                name = "ntp-servers";
                data = "192.168.0.1";
              }
              {
                name = "domain-name-servers";
                data = with config.fugi.machines;
                  "${librarian.IPv4.address}, ${shepherd.IPv4.address}";
              }
            ];
            reservations = [
              {
                # schnurbsi
                hw-address = "70:C9:32:0B:1F:5E";
                ip-address = "192.168.0.7";
              }
            ];
          }];
        };
      };
    };

    services.radvd = {
      enable = true;
      config = ''
        interface ${config.fugi.dhcp.interface} {
          AdvSendAdvert on;
          AdvDefaultLifetime 0;
          AdvCurHopLimit 0;
          AdvOtherConfigFlag on;
          RDNSS ${machineConfig.IPv6.address} { };
        };
      '';
    };
  };
}
