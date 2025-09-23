{ config, lib, pkgs, ... }:
let
  cfg = config.wayland.windowManager.sway;

  mod = "Mod4";

  mkScreenshotKeybindings = { baseKeybinds, commands }: builtins.listToAttrs (
    builtins.concatMap
      (keybind: (builtins.map
        ({ modifier, target }: {
          name = keybind + modifier;
          value = "exec wl-copy < $(grimshot save ${target})";
        })
        commands
      ))
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
    ./wofi.nix
    ./theme.nix
    ./waybar
    ./polkit-agent.nix
    ./swaync.nix
  ];

  wayland.windowManager.sway = {
    enable = true;

    package = pkgs.swayfx.override {
      extraSessionCommands = cfg.extraSessionCommands;
      extraOptions = cfg.extraOptions;
      withBaseWrapper = cfg.wrapperFeatures.base;
      withGtkWrapper = cfg.wrapperFeatures.gtk;
    };

    checkConfig = false;

    extraSessionCommands = ''
      export NIXOS_OZONE_WL=1
      export XDG_SCREENSHOTS_DIR=~/Pictures/screenshots
      unset __HM_ZSH_SESS_VARS_SOURCED
    '';

    extraConfigEarly = ''
      set $mode_power (l)ock, (e)xit, (s)uspend, (p)oweroff, (r)eboot
    '';

    extraConfig = ''
      titlebar_padding 5 1
      for_window [app_id="com.github.iwalton3.jellyfin-media-player"] inhibit_idle visible
      for_window [app_id="com.obsproject.Studio"] inhibit_idle visible
      for_window [app_id="pinentry-qt"] focus

      layer_effects "swaync-notification-window" {
        blur enable;
        blur_ignore_transparent enable;
      }
      layer_effects "swaync-control-center" {
        blur enable;
        blur_ignore_transparent enable;
      }
      layer_effects "wofi" {
        blur enable;
        blur_ignore_transparent enable;
      }
    '';

    config = {
      modifier = mod;
      terminal = "foot";

      focus = {
        followMouse = false;
        wrapping = "yes";
      };

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
          { app_id = "pwvucontrol"; }
          { app_id = "de.haeckerfelix.AudioSharing"; }
          { app_id = "blueman-manager"; }
          { app_id = "nm-connection-editor"; }
          { title = "File Operation Progress"; }
          { app_id = "lxqt-policykit-agent"; }
          { app_id = "org.bunkus.mkvtoolnix-gui"; title = "Edit language"; }
          { app_id = "pcmanfm-qt"; title = "Copy Files"; }
          { title = "Extracting Files — Ark"; }
          { app_id = "naps2"; title = "^(?!NAPS2|Preview)"; }
        ];
      };

      modes = lib.mkOptionDefault {
        "$mode_power" = {
          l = "exec loginctl lock-session, mode default";
          e = "exec uwsm stop";
          s = "exec systemctl suspend, mode default";
          p = "exec systemctl poweroff";
          r = "exec systemctl reboot";
          Escape = "mode default";
        };
      };

      keybindings = lib.mkOptionDefault ({
        "${mod}+d" = "exec wofi --show drun --no-actions";
        "${mod}+b" = "exec firefox";
        "${mod}+period" = "exec rofimoji --selector wofi";
        "${mod}+l" = "exec loginctl lock-session";
        "${mod}+t" = "exec thunar";
        # display brightness
        "--locked XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 10";
        "--locked XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 10";
        # keyboard brightness
        "--locked Shift+XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 10 -s sysfs/leds/kbd_backlight";
        "--locked Shift+XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 10 -s sysfs/leds/kbd_backlight";
        # media control
        "XF86AudioRaiseVolume" = "exec wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
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

      bars = [ ];
    };
  };

  services.swayidle =
    let
      lockCmd = "${lib.getExe pkgs.gtklock} -d";
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
    (rofimoji.override {
      x11Support = false;
    })
  ];
}
