{ config, lib, pkgs, ... }:
let
  sway = if config ? home-manager
    then config.home-manager.users.fugi.wayland.windowManager.sway.package
    else pkgs.sway;
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.zsh}/bin/zsh --login -c '${pkgs.systemd}/bin/systemd-inhibit --what=handle-power-key --mode=block --who=sway ${lib.getExe sway}'";
        user = "fugi";
      };
    };
  };
}
