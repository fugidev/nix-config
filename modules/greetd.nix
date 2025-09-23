{ pkgs, ... }:
let
  shell = pkgs.writeScript "exec-login-shell" ''
    exec -l /run/current-system/sw/bin/zsh
  '';
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd}/bin/agreety --cmd ${shell}";
        user = "greeter";
      };
      initial_session = {
        command = shell;
        user = "fugi";
      };
    };
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="drm", KERNEL=="card*", TAG+="systemd"
  '';
}
