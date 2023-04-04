{ config, lib, pkgs, ... }@args:
let
  mod = "Mod4";

  mkScreenshotKeybindings = { baseKeybinds, commands }: builtins.listToAttrs (
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

  screenshotKeybindings = mkScreenshotKeybindings {
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

    extraConfigEarly = ''
      set $mode_power (l)ock, (e)xit, (s)uspend, (p)oweroff, (r)eboot
    '';

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
          { app_id = "de.haeckerfelix.AudioSharing"; }
          { title = "File Operation Progress"; }
        ];
      };

      modes = lib.mkOptionDefault {
        "$mode_power" = {
          l = "exec loginctl lock-session, mode default";
          e = "exec swaymsg exit";
          s = "exec systemctl suspend, mode default";
          p = "exec systemctl poweroff";
          r = "exec systemctl reboot";
          Escape = "mode default";
        };
      };

      keybindings = lib.mkOptionDefault ({
        "${mod}+d" = "exec rofi -show drun";
        "${mod}+b" = "exec firefox";
        "${mod}+period" = "exec rofimoji";
        "${mod}+l" = "exec loginctl lock-session";
        # display brightness
        "--locked XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 10";
        "--locked XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 10";
        # modes
        "${mod}+Pause" = "mode \"$mode_power\"";
        "XF86PowerOff" = "mode \"$mode_power\""; # systemd-inhibit required for this
      } // screenshotKeybindings);

      seat."*" = let cursor = config.home.pointerCursor; in {
        xcursor_theme = "${cursor.name} ${builtins.toString cursor.size}";
      };

      bars = [{
        command = "${pkgs.waybar}/bin/waybar";
      }];
    };
  };

  services.swayidle = let
    swaylock = (if args ? "nixosConfig" then "${pkgs.swaylock-effects}/bin/" else "/usr/bin/") + "swaylock";
    lockCmd = "${swaylock} -f -c 000000 --clock --indicator-idle-visible";
  in {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = lockCmd;
      }
      {
        event = "lock";
        command = lockCmd;
      }
    ];
  };

  home.packages = with pkgs; [
    light
    sway-contrib.grimshot
    wl-clipboard
  ];
}
