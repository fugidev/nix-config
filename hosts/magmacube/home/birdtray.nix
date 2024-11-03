{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (makeAutostartItem {
      name = "com.ulduzsoft.Birdtray";
      package = birdtray;
    })
  ];

  xdg.configFile."systemd/user/app-com.ulduzsoft.Birdtray@autostart.service.d/overrides.conf".text = ''
    [Service]
    ExecStartPre=${pkgs.coreutils}/bin/sleep 30
  '';
}
