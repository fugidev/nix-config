{ inputs, ... }:
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
      wallpaper.enabled = false;
      dock.enabled = false;
      location.name = "Dresden";

      general = {
        enableShadows = false;
        iRadiusRatio = 0.65;
        radiusRatio = 0.5;
        screenRadiusRatio = 0.5;
        dimmerOpacity = 0;
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
            { id = "NotificationHistory"; }
            { id = "Battery"; }
            {
              id = "Volume";
              displayMode = "alwaysShow";
            }
            { id = "Brightness"; }
            { id = "Bluetooth"; }
            { id = "Network"; }
            { id = "ControlCenter"; }
          ];
        };
      };
    };
  };
}
