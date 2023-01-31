{ config, pkgs, lib, ... }: with lib; {
  options.fugi = {
    promptColor = mkOption {
      type = types.str;
      description = "zsh prompt color";
      default = "blue";
    };
  };
}
