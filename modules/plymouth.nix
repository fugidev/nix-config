{ pkgs, ... }:
{
  boot.plymouth = {
    enable = true;
    theme = "spinner";
    font = "${pkgs.fira-code}/share/fonts/truetype/FiraCode-VF.ttf";
  };

  boot.kernelParams = [
    "quiet"
    "splash"
    "plymouth.use-simpledrm=0"
    "rd.udev.log_priority=3"
    "systemd.show_status=auto"
  ];
}
