{ config, lib, ... }:
let
  inherit (lib) mkOption types;

  fromCidr = cidr:
    let
      parts = lib.splitString "/" cidr;
    in {
      address = builtins.elemAt parts 0;
      prefixLength = lib.toInt (builtins.elemAt parts 1);
    };

  toCidr = address: prefixLength: "${address}/${toString prefixLength}";

  validCidr = ip: ip.cidr == toCidr ip.address ip.prefixLength;

  IP = ({ config, ... }: {
    options = {
      address = mkOption {
        type = types.str;
        default = (fromCidr config.cidr).address;
      };

      prefixLength = mkOption {
        type = types.int;
        default = (fromCidr config.cidr).prefixLength;
      };

      cidr = mkOption {
        type = types.str;
        default = toCidr config.address config.prefixLength;
      };
    };
  });

  machine = ({ name, config, ... }: {
    options = {
      IPv4 = mkOption {
        type = types.nullOr (types.submodule IP);
        default = null;
      };

      IPv6 = mkOption {
        type = types.nullOr (types.submodule IP);
        default = null;
      };

      domain = mkOption {
        type = types.str;
        default = "fugi.dev";
      };

      hostName = mkOption {
        type = types.str;
        default = name;
        readOnly = true;
      };

      fqdn = mkOption {
        type = types.str;
        default = "${name}.${config.domain}";
        readOnly = true;
      };

      baseDomain = mkOption {
        type = types.str;
        default = config.fqdn;
        description = "Base domain for web services";
      };
    };
  });
in
{
  options.fugi = {
    machines = mkOption {
      type = types.attrsOf (types.submodule machine);
    };
  };

  config = {
    assertions = builtins.concatMap
      (machine:
        lib.optional (machine.IPv4 != null) {
          assertion = validCidr machine.IPv4;
          message = "machine ${machine.hostname}: IPv4 cidr mismatch";
        }
        ++ lib.optional (machine.IPv6 != null) {
          assertion = validCidr machine.IPv6;
          message = "machine ${machine.hostname}: IPv6 cidr mismatch";
        }
      )
      (builtins.attrValues config.fugi.machines);

    fugi.machines = {
      librarian = {
        IPv4.cidr = "192.168.0.3/24";
        IPv6.cidr = "fd00::3/64";
      };
      shepherd = {
        IPv4.cidr = "192.168.0.4/24";
        IPv6.cidr = "fd00::4/64";
      };
      nitwit = {
        IPv4.cidr = "178.254.28.214/22";
      };
      cleric = {
        IPv4.cidr = "152.53.103.37/22";
        IPv6.cidr = "2a0a:4cc0:80:20f8::1/64";
        baseDomain = "fugi.dev";
      };
      blaze = { };
    };
  };
}
