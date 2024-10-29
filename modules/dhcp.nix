{ config, lib, ... }:
{
  options = {
    fugi.dhcp4 = {
      interface = lib.mkOption {
        type = lib.types.str;
      };
      pool = lib.mkOption {
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
          interfaces-config.interfaces = [ config.fugi.dhcp4.interface ];
          lease-database = {
            name = "/var/lib/kea/dhcp4.leases";
            type = "memfile";
          };
          subnet4 = [{
            subnet = "192.168.0.0/24";
            pools = [{
              inherit (config.fugi.dhcp4) pool;
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
          }];
        };
      };
    };
  };
}
