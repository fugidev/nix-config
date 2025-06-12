{ config, lib, ... }:
let
  inherit (lib) mkOption types;

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
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLIO/G4CCySDUmi9CQrq05CpWyfTmdv/Y9AJa/IOSNyg9/2hWRD+eL0JeKw+2Z6smH+kRheVVMya2YYckVWjso0="
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

    allowInsecure = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
  };

  config = {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.fugi.allowUnfree;
    nixpkgs.config.permittedInsecurePackages = config.fugi.allowInsecure;
  };
}
