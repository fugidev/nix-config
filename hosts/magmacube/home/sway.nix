{ config, pkgs, flakeRoot, ... }:
let
  monitor_l = "HDMI-A-1";
  monitor_c = "DP-1";
  monitor_r = "DP-2";

  wsOutputMap = output: map (ws: { inherit output; workspace = toString ws; });

  swayCfg = config.wayland.windowManager.sway;
in
{
  imports = [
    (flakeRoot + /modules/home/sway.nix)
  ];

  wayland.windowManager.sway = {
    config = {
      focus.mouseWarping = false;

      fonts.size = 10.0;

      workspaceOutputAssign =
        wsOutputMap monitor_l [ 1 2 3 ] ++
        wsOutputMap monitor_c [ 4 5 6 ] ++
        wsOutputMap monitor_r [ 7 8 9 ];

      output =
        let
          mode = "2560x1440@144Hz";
          bg = "${config.fugi.wallpaper} fill";
        in
        {
          ${monitor_l} = {
            inherit mode bg;
            pos = "0 0";
            transform = "270";
          };
          ${monitor_c} = {
            inherit mode bg;
            pos = "1440 780";
          };
          ${monitor_r} = {
            inherit mode bg;
            pos = "4000 0";
            transform = "90";
          };
        };

      input = {
        "type:keyboard" = {
          xkb_layout = "de";
          xkb_numlock = "enabled";
        };
      };

      startup = [
        { command = "MOZ_ENABLE_WAYLAND=0 thunderbird"; }
        { command = "lxqt-policykit-agent"; }
        { command = "blueman-applet"; }
      ];
    };
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        # lock session and turn off displays after 15 minutes
        timeout = 900;
        command = "${pkgs.systemd}/bin/loginctl lock-session; ${swayCfg.package}/bin/swaymsg 'output * dpms off'";
        resumeCommand = "${swayCfg.package}/bin/swaymsg 'output * dpms on'";
      }
    ];
  };
}
