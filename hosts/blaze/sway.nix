{ config, lib, pkgs, ... }:
{
  imports = [
    ../../modules/home/sway.nix
  ];

  wayland.windowManager.sway = {
    config = {
      input = {
        "type:keyboard" = {
          xkb_layout = "de";
        };
        "type:touchpad" = {
          natural_scroll = "enabled";
          scroll_factor = "0.5";
        };
      };

      output = {
        "eDP-1" = {
          scale = "1.5";
          subpixel = "vbgr";
          scale_filter = "linear";
          bg = "${config.fugi.wallpaper} fill";
        };
      };

      startup = [
        { command = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"; }
      ];
    };
  };

  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.systemd}/bin/loginctl lock-session";
      }
      {
        event = "lock";
        command = "${pkgs.swaylock-effects}/bin/swaylock -c 000000 --clock --indicator-idle-visible";
      }
    ];
    timeouts = [
      {
        # lock session after 5 minutes
        timeout = 300;
        command = "${pkgs.systemd}/bin/loginctl lock-session";
      }
      {
        # dim display after 4 minutes
        timeout = 240;
        command = "${pkgs.light}/bin/light -T 0.25";
        resumeCommand = "${pkgs.light}/bin/light -T 4";
      }
    ];
  };
}
