{ config, lib, pkgs, ... }:
let
  sway = config.home-manager.users.fugi.wayland.windowManager.sway.package;
  systemd-inhibit = "${pkgs.systemd}/bin/systemd-inhibit --what=handle-power-key --mode=block --who=sway";
  systemd-cat = "${pkgs.systemd}/bin/systemd-cat --identifier=sway";

  run-sway = pkgs.writeScript "run-sway" ''
    if [ $UID -eq 0 ]; then
      echo "starting sway as root is forbidden."
      exit
    fi

    exec zsh --login -c '${systemd-inhibit} ${systemd-cat} ${lib.getExe sway}'
  '';
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.greetd}/bin/agreety --cmd ${run-sway}";
        user = "greeter";
      };
      initial_session = {
        command = run-sway;
        user = "fugi";
      };
    };
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="drm", KERNEL=="card*", TAG+="systemd"
  '';
}
