{ config, lib, pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.zsh}/bin/zsh --login -c ${pkgs.sway}/bin/sway";
        user = "fugi";
      };
    };
  };
}
