{ config, pkgs, lib, ... }: with lib; {
  options.fugi = {
    wallpaper = mkOption {
      type = types.path;
      description = "desktop and lockscreen background";
    };
  };
}
