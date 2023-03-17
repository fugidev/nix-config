{ config, lib, pkgs, ... }:
let
  mod = "Mod4";
in
{
  imports = [
    ./rofi.nix
    ./theme.nix
  ];

  wayland.windowManager.sway = {
    enable = true;

    wrapperFeatures.gtk = true;

    extraConfig = ''
      titlebar_padding 5 1
    '';

    config = {
      modifier = mod;
      terminal = "foot";

      focus.followMouse = false;

      window = {
        border = 1;
        titlebar = true;
      };

      floating = {
        border = 1;
        titlebar = true;

        # swaymsg -t get_tree
        criteria = [
          { app_id = "qalculate-gtk"; }
          { app_id = "pavucontrol"; }
        ];
      };

      keybindings = lib.mkOptionDefault {
        "${mod}+d" = "exec rofi -show drun";
        "${mod}+b" = "exec firefox";
        "${mod}+period" = "exec rofimoji";
        "${mod}+l" = "exec loginctl lock-session";
        "--locked XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 10";
        "--locked XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 10";
      };

      seat."*" = let cursor = config.home.pointerCursor; in {
        xcursor_theme = "${cursor.name} ${builtins.toString cursor.size}";
      };
    };
  };

  home.packages = with pkgs; [
    swaylock-effects
    light
  ];
}
