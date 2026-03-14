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

  wofi = pkgs.writeScript "wofi-app2unit" ''
    set -e
    desktop_file="$(wofi --show drun --define=drun-print_desktop_file=true --no-actions)"
    exec app2unit -- "$(basename $desktop_file)"
  '';

  noctalia-ipc = cmd: "exec noctalia-shell ipc call ${cmd}";
in
{
  imports = [
    ./wofi.nix
    ./theme.nix
    ./polkit-agent.nix
    ./noctalia.nix
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
      terminal = "app2unit -T";

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

      keybindings = lib.mkOptionDefault ({
        "${mod}+d" = "exec ${wofi}";
        "${mod}+period" = "exec rofimoji --selector wofi";
        "${mod}+l" = "exec loginctl lock-session";
        # app shortcuts
        "${mod}+b" = "exec app2unit -- librewolf.desktop";
        "${mod}+t" = "exec app2unit -- thunar.desktop";
        # display brightness
        "--locked XF86MonBrightnessUp" = noctalia-ipc "brightness increase";
        "--locked XF86MonBrightnessDown" = noctalia-ipc "brightness decrease";
        # media control
        "XF86AudioRaiseVolume" = noctalia-ipc "volume increase";
        "XF86AudioLowerVolume" = noctalia-ipc "volume decrease";
        "XF86AudioMute" = noctalia-ipc "volume muteOutput";
        "XF86AudioMicMute" = noctalia-ipc "volume muteInput";
        "XF86AudioPlay" = noctalia-ipc "media playPause";
        "XF86AudioNext" = noctalia-ipc "media next";
        "XF86AudioPrev" = noctalia-ipc "media previous";
        # session menu
        "${mod}+Pause" = noctalia-ipc "sessionMenu toggle";
        "XF86PowerOff" = noctalia-ipc "sessionMenu toggle"; # systemd-inhibit required for this
      } // screenshotKeybindings);

      seat."*" = let cursor = config.home.pointerCursor; in {
        xcursor_theme = "${cursor.name} ${builtins.toString cursor.size}";
      };

      bars = [ ];
    };
  };

  services.swayidle = {
    enable = true;
    events = rec {
      lock = "${lib.getExe pkgs.gtklock} -d";
      before-sleep = lock;
    };
  };

  services.playerctld.enable = true;

  home.packages = with pkgs; [
    sway-contrib.grimshot
    wl-clipboard
    (rofimoji.override {
      x11Support = false;
    })
  ];
}
