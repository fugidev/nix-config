{ config, lib, pkgs, ... }:
let
  mod = "Mod4";
in
{
  imports = [
    ./bar.nix
    ./rofi.nix
    ./theme.nix
  ];

  wayland.windowManager.sway = {
    enable = true;

    wrapperFeatures.gtk = true;

    extraConfig =
      let
        cursor = config.home.pointerCursor;
      in
      ''
        titlebar_padding 5 1
        seat seat0 xcursor_theme ${cursor.name} ${builtins.toString cursor.size}
      '';

    config = {
      modifier = mod;

      focus.followMouse = false;

      window = {
        border = 1;
        titlebar = true;
      };

      floating = {
        border = 1;
        titlebar = true;
      };

      keybindings = lib.mkOptionDefault {
        "${mod}+d" = "exec rofi -show drun";
        "${mod}+b" = "exec firefox";
        "${mod}+period" = "exec rofimoji";
        "${mod}+l" = "exec loginctl lock-session";
        "--locked XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 10";
        "--locked XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 10";
      };

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

      bars = [{
        position = "top";
        statusCommand = "i3status-rs ${config.xdg.configHome}/i3status-rust/config-top.toml";
      }];
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
        # lock session and turn off display after 5 minutes
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

  home.packages = with pkgs; [
    swaylock-effects
    light
  ];
}
