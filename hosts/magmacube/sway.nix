{ config, lib, pkgs, ... }:

let
  monitor_l = "HDMI-A-1";
  monitor_c = "DP-2";
  monitor_r = "DP-1";

  wsOutputMap = output: map (ws: { inherit output; workspace = toString ws; });
in
{
  imports = [
    ../../modules/home/sway.nix
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
            pos = "1440 870";
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
        };
      };
    };
  };

  # TODO: swayidle
}
