{ config, lib, pkgs, ... }:
{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "clock" ];
        modules-right = [ "disk" "memory" "network" "cpu" "pulseaudio" "tray" ];

        "sway/workspaces" = {
          disable-scroll = true;
        };

        "clock" = {
          # see https://howardhinnant.github.io/date/date.html#to_stream_formatting
          format = "{:%a %F %T}";
          interval = 1;
        };

        "cpu" = {
          format = "{usage}% {load} ";
        };

        "pulseaudio" = {
          on-click = "pavucontrol";
        };

        "tray" = {
          spacing = 5;
        };
      };
    };

    style = ''
      * {
        font-family: monospace;
        font-size: 10pt;
      }

      window#waybar {
        background-color: #111111;
        color: #ffffff;
      }

      .modules-left {
        padding: 0;
      }

      .modules-right {
        padding: 0;
      }

      #workspaces button {
        min-height: 20px;
        padding: 0 5px;
        min-width: 1px;
        color: #888;
        border-radius: 0;
        background-color: #222;
        border: 1px solid #333;
      }

      #workspaces button.visible {
        background: #5f676a;
        color: #fff;
        border: 1px solid #888;
      }

      #workspaces button.focused {
        background-color: #285577;
        color: #fff;
        border: 1px solid #4c7899;
      }

      #mode {
        background-color: #900000;
        color: #ffffff;
        padding: 0px 5px 0px 5px;
        border: 1px solid #2f343a;
      }

      #window {
        color: #ffffff;
        background-color: #285577;
        padding: 0px 10px 0px 10px;
      }

      window#waybar.empty #window {
        background-color: transparent;
        color: transparent;
      }

      window#waybar.empty {
        background-color: #323232;
      }

      .modules-right > * > * {
        padding: 0 10px;
        border-right: 1px solid #333;
      }
      .modules-right > :last-child > * {
        border-right: none;
      }
    '';
  };

  # enable icon font
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    font-awesome
    pavucontrol
  ];
}
