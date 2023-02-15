{ config, pkgs, lib, ... }: with lib; {
  options.fugi = {
    promptColor = mkOption {
      type = types.str;
      description = "zsh prompt color";
      default = "blue";
    };

    authorizedKeys = mkOption {
      type = types.listOf types.str;
      default = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA0X6L7NwTHiOmFzo8mJBCy6H+DKUePAAXU4amm32DAQ fugi@magmacube"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHD1ZkrAmC9g5eJPDgv4zuEM+UIIEWromDzM1ltHt4TM fugi@blaze"
      ];
    };

    domain = mkOption {
      type = types.str;
    };
  };
}
