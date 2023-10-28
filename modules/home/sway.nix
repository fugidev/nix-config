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
      for_window [app_id="org.jellyfin.jellyfinmediaplayer"] inhibit_idle visible
      for_window [app_id="pinentry-qt"] focus
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
          { app_id = "blueman-manager"; }
          { app_id = "nm-connection-editor"; }
          { title = "File Operation Progress"; }
          { app_id = "lxqt-policykit-agent"; }
          { app_id = "org.bunkus.mkvtoolnix-gui"; title = "Edit language"; }
          { app_id = "pcmanfm-qt"; title = "Copy Files"; }
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
        "${mod}+t" = "exec thunar";
        # display brightness
        "--locked XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 10";
        "--locked XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 10";
        # media control
        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
        "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
        "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
        # modes
        "${mod}+Pause" = "mode \"$mode_power\"";
        "XF86PowerOff" = "mode \"$mode_power\""; # systemd-inhibit required for this
      } // screenshotKeybindings);

      seat."*" = let cursor = config.home.pointerCursor; in {
        xcursor_theme = "${cursor.name} ${builtins.toString cursor.size}";
      };

      bars = [{
        command = "${config.programs.waybar.package}/bin/waybar";
      }];
    };
  };

  services.swayidle =
    let
      swaylock = (if args ? "nixosConfig" then "${pkgs.swaylock-effects}/bin/" else "/usr/bin/") + "swaylock";
      lockCmd = "${swaylock} -f -c 000000 --clock --indicator-idle-visible";
    in
    {
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

  services.playerctld.enable = true;

  home.packages = with pkgs; [
    light
    sway-contrib.grimshot
    wl-clipboard
  ];
}
