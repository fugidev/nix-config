{ config, lib, pkgs, ... }:
let
  mod = "Mod4";

  genScreenshotKeybindings = { baseKeybinds, commands }: builtins.listToAttrs (
    builtins.concatMap
      (
        keybind: (
          builtins.map
            ({ modifier, target }:
              {
                name = keybind + modifier;
                value = "exec wl-copy < $(grimshot save ${target})";
              }
            )
            commands
        )
      )
      baseKeybinds
  );

  screenshotKeybindings = genScreenshotKeybindings {
    baseKeybinds = [ "${mod}+p" "Print" ];
    commands = [
      { modifier = ""; target = "area"; }
      { modifier = "+Shift"; target = "active"; }
      { modifier = "+Control"; target = "output"; }
    ];
  };
in
{
  imports = [
    ./rofi.nix
    ./theme.nix
    ./waybar.nix
  ];

  wayland.windowManager.sway = {
    enable = true;
    package = null;

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

      keybindings = lib.mkOptionDefault ({
        "${mod}+d" = "exec rofi -show drun";
        "${mod}+b" = "exec firefox";
        "${mod}+period" = "exec rofimoji";
        "${mod}+l" = "exec loginctl lock-session";
        # display brightness
        "--locked XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 10";
        "--locked XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 10";
      } // screenshotKeybindings);

      seat."*" = let cursor = config.home.pointerCursor; in {
        xcursor_theme = "${cursor.name} ${builtins.toString cursor.size}";
      };

      startup = [
        { command = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"; }
      ];

      bars = [{
        command = "${pkgs.waybar}/bin/waybar";
      }];
    };
  };

  home.packages = with pkgs; [
    swaylock-effects
    light
    sway-contrib.grimshot
    wl-clipboard
  ];
}
