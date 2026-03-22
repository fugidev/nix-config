{ config, pkgs, inputs, osConfig, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;

    # Catppuccin Lavender
    colors = {
      mError = "#f38ba8";
      mHover = "#c6a0f6";
      mOnError = "#11111b";
      mOnHover = "#11111b";
      mOnPrimary = "#11111b";
      mOnSecondary = "#11111b";
      mOnSurface = "#cdd6f4";
      mOnSurfaceVariant = "#a3b4eb";
      mOnTertiary = "#11111b";
      mOutline = "#4c4f69";
      mPrimary = "#b4befe";
      mSecondary = "#f5bde6";
      mShadow = "#11111b";
      mSurface = "#1e1e2e";
      mSurfaceVariant = "#313244";
      mTertiary = "#c6a0f6";
    };

    settings = {
      dock.enabled = false;
      location.name = "Dresden";

      general = {
        enableShadows = false;
        iRadiusRatio = 0.65;
        radiusRatio = 0.5;
        screenRadiusRatio = 0.5;
        dimmerOpacity = 0;

        compactLockScreen = true;
        showSessionButtonsOnLockScreen = false;
      };

      bar = {
        enableExclusionZoneInset = false;
        outerCorners = false;
        showCapsule = false;
        widgets = {
          left = [
            { id = "Launcher"; }
            {
              id = "Clock";
              useCustomFont = true;
              customFont = "Fira Code";
            }
            {
              id = "SystemMonitor";
              compactMode = false;
              showDiskAvailable = true;
              showDiskUsage = true;
              showMemoryAsPercent = true;
              showNetworkStats = true;
            }
          ];
          center = [
            {
              id = "Workspace";
              emptyColor = "primary";
              focusedColor = "tertiary";
              occupiedColor = "primary";
              enableScrollWheel = false;
              pillSize = 0.85;
            }
          ];
          right = [
            {
              id = "MediaMini";
              hideMode = "idle";
              maxWidth = 250;
            }
            {
              id = "Tray";
              hidePassive = true;
            }
            {
              id = "Battery";
              displayMode = "icon-always";
            }
            {
              id = "Volume";
              displayMode = "alwaysShow";
            }
            {
              id = "Network";
              displayMode = if osConfig.networking.hostName == "magmacube" then "alwaysHide" else "alwaysShow";
            }
            { id = "Bluetooth"; }
            { id = "NotificationHistory"; }
            {
              id = "ControlCenter";
              icon = "adjustments-horizontal";
            }
          ];
        };
      };

      sessionMenu = {
        enableCountdown = false;
        powerOptions = [
          {
            action = "lock";
            keybind = "L";
            enabled = true;
          }
          {
            action = "logout";
            command = "uwsm stop";
            keybind = "E";
            enabled = true;
          }
          {
            action = "suspend";
            keybind = "S";
            enabled = true;
          }
          {
            action = "reboot";
            keybind = "R";
            enabled = true;
          }
          {
            action = "shutdown";
            keybind = "P";
            enabled = true;
          }
        ];
      };
    };
  };

  home.file.".cache/noctalia/wallpapers.json" = {
    text = builtins.toJSON {
      defaultWallpaper = config.fugi.wallpaper;
    };
  };

  home.packages = [
    (pkgs.writeShellApplication {
      name = "noctalia-config-diff";
      runtimeInputs = with pkgs; [
        json-diff
        jq
        config.programs.noctalia-shell.package
      ];
      text = ''
        json-diff -fC \
          <(jq -Ss '.[0] * .[1]' ${config.programs.noctalia-shell.package.src}/Assets/settings-default.json ~/.config/noctalia/settings.json) \
          <(noctalia-shell ipc call state all | jq -S .settings) \
          | less
      '';
    })
  ];
}
