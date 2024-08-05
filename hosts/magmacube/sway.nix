{ config, lib, ... }:

let
  monitor_l = "HDMI-A-1";
  monitor_c = "DP-1";
  monitor_r = "DP-2";

  wsOutputMap = output: map (ws: { inherit output; workspace = toString ws; });
in
{
  imports = [
    ../../modules/home/sway.nix
  ];

  home.sessionVariablesExtra = lib.mkAfter ''
    unset QT_PLUGIN_PATH QML2_IMPORT_PATH
  '';

  systemd.user.sessionVariables = {
    QML2_IMPORT_PATH = lib.mkForce "";
    QT_PLUGIN_PATH = lib.mkForce "";
  };

  wayland.windowManager.sway = {
    # don't add sway to path
    package = null;

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

    extraConfig = ''
      include /etc/sway/config.d/*
    '';
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        # lock session after 15 minutes
        timeout = 900;
        command = "/usr/bin/loginctl lock-session";
      }
    ];
  };

}
