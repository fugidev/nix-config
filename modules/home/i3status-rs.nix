{ config, pkgs, lib, ... }:
{
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

  # enable icon font
  fonts.fontconfig.enable = true;
  home.packages = [ pkgs.font-awesome ];
}
