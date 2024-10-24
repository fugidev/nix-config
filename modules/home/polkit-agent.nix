{ config, pkgs, ... }:
{
  home.packages = [
    # make it autostart-able
    (pkgs.symlinkJoin {
      name = "lxqt-policykit-patched";
      paths = [ pkgs.lxqt.lxqt-policykit ];
      nativeBuildInputs = [ pkgs.gnused ];
      postBuild = ''
        sed -i '/OnlyShowIn/d' $out/etc/xdg/autostart/lxqt-policykit-agent.desktop
      '';
    })
  ];

  # make its windows float
  xdg.configFile."systemd/user/app-lxqt\\x2dpolicykit\\x2dagent@autostart.service.d/overrides.conf".text = ''
    [Service]
    ExecStartPost=/bin/sh -c '${config.wayland.windowManager.sway.package}/bin/swaymsg for_window [pid=$MAINPID] floating enable'
  '';
}
