{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;

    systemd = {
      enable = true;
      target = "sway-session.target";
    };

    package = pkgs.waybar.overrideAttrs (_old: {
      patches = [ ./0001-bandwidth-units.patch ];
    });

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "clock" ];
        modules-right = [ "network" "disk" "memory" "cpu" "pulseaudio" "battery" "tray" ];

        "sway/workspaces" = {
          disable-scroll = true;
        };

        "clock" = {
          # see https://howardhinnant.github.io/date/date.html#to_stream_formatting
          format = "{:%a %F %T}";
          interval = 1;
        };

        "network" =
          let
            details = " {ipaddr}/{cidr}   {bandwidthDownBytes}  {bandwidthUpBytes}";
          in
          {
            format-wifi = " {essid}" + details;
            format-ethernet = "" + details;
            format-disconnected = "Disconnected";
            interval = 10;
          };

        "disk" = {
          format = " {free}";
        };

        "memory" = {
          format = " {used:0.1f}G/{total:0.1f}G ({percentage}%)";
        };

        "cpu" = {
          format = "{usage:3}%";
        };

        "pulseaudio" = {
          format = " {volume}%";
          format-bluetooth = " {volume}%";
          format-muted = " Mute";
          on-click = "pavucontrol";
        };

        "battery" = {
          format = "{icon} {capacity}%";
          format-icons = [ "" "" "" "" "" ];
          states = {
            warning = 25;
            critical = 10;
          };
        };

        "tray" = {
          spacing = 5;
        };
      };
    };

    style = /* css */ ''
      * {
        font-family: "Fira Code", "Font Awesome 6 Free";
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
        margin-left: 10px;
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

      #battery {
        background-color: unset;
      }
      #battery.warning {
        color: #f67400;
      }
      #battery.critical {
        color: #d0312d;
      }
      #battery.charging {
        color: #5dbb63;
      }
    '';
  };

  # enable icon font
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    font-awesome
    pavucontrol
  ];

  # otherwise it breaks for no reason
  systemd.user.services."waybar".Service.Environment = ''
    LC_TIME=en_US.UTF-8
  '';
}
