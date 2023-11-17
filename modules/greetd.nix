{ pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.zsh}/bin/zsh --login -c '${pkgs.systemd}/bin/systemd-inhibit --what=handle-power-key --mode=block --who=sway ${pkgs.sway}/bin/sway'";
        user = "fugi";
      };
    };
  };
}
