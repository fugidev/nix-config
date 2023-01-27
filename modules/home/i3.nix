{ config, pkgs, lib, ... }:
let
  mod = "Mod4";
in
{
  imports = [
    ./rofi.nix
    ./x-screen-locker.nix
    ./theme.nix
  ];

  xsession.enable = true;
  xsession.windowManager.i3 = {
    enable = true;

    config = {
      modifier = mod;

      defaultWorkspace = "workspace number 1";

      window.border = 1; # uses "logical" pixels, so actually more on hidpi display

      focus.followMouse = false;

      startup = [
        {
          # set wallpaper
          command = "feh --no-fehbg --bg-fill ${config.fugi.wallpaper}";
          notification = false;
          always = true;
        }
      ];

      bars = [{
        position = "top";
        statusCommand = "i3status-rs ${config.xdg.configHome}/i3status-rust/config-top.toml";
      }];

      keybindings = lib.mkOptionDefault {
        "${mod}+d" = "exec rofi -show drun";
        "${mod}+b" = "exec firefox";
        "${mod}+colon" = "exec rofimoji";
        "${mod}+l" = "exec loginctl lock-session";
        "XF86MonBrightnessUp" = "exec xbacklight -set 100";
        "XF86MonBrightnessDown" = "exec xbacklight -set 0";
      };
    };
  };

  # enable icon font
  fonts.fontconfig.enable = true;
  home.packages = [ pkgs.font-awesome ];

  # status bar
  programs.i3status-rust = {
    enable = true;

    bars.top = {
      icons = "awesome6";
      blocks = [
        {
          block = "networkmanager";
        }
        {
          block = "net";
        }
        {
          block = "disk_space";
          format = "{icon} {available}";
        }
        {
          block = "memory";
          clickable = false;
        }
        {
          block = "cpu";
        }
        {
          block = "battery";
          full_format = "{percentage}";
        }
        {
          block = "time";
          format = "%a %F %T";
          interval = 1;
        }
      ];
    };
  };
}
