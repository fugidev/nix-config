{ config, lib, pkgs, ... }:
let
  inherit (lib) getExe;

  sway = config.home-manager.users.fugi.wayland.windowManager.sway.package or pkgs.sway;
  systemd-inhibit = "${pkgs.systemd}/bin/systemd-inhibit --what=handle-power-key --mode=block --who=sway";
  systemd-cat = "${pkgs.systemd}/bin/systemd-cat --identifier=sway";
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${getExe pkgs.zsh} --login -c '${systemd-inhibit} ${systemd-cat} ${getExe sway}'";
        user = "fugi";
      };
    };
  };
}
