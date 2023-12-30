{ config, lib, ... }:

with lib;

let
  IP = {
    options = {
      address = mkOption {
        type = types.str;
      };
      prefixLength = mkOption {
        type = types.int;
      };
    };
  };
in
{
  options.fugi = {
    authorizedKeys = mkOption {
      type = types.listOf types.str;
      default = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA0X6L7NwTHiOmFzo8mJBCy6H+DKUePAAXU4amm32DAQ fugi@magmacube"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHD1ZkrAmC9g5eJPDgv4zuEM+UIIEWromDzM1ltHt4TM fugi@blaze"
      ];
    };

    staticIPv4 = mkOption {
      type = types.submodule IP;
    };

    staticIPv6 = mkOption {
      type = types.submodule IP;
    };

    allowUnfree = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };

    baseDomain = mkOption {
      type = types.str;
      default = config.networking.fqdn;
    };
  };

  config = {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.fugi.allowUnfree;
  };
}
