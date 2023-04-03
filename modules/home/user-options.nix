{ config, pkgs, lib, ... }: with lib; {
  options.fugi = {
    wallpaper = mkOption {
      type = types.path;
      description = "desktop and lockscreen background";
    };

    guiApps = mkOption {
      type = types.bool;
      description = "install gui applications";
      default = false;
    };

    promptColor = mkOption {
      type = types.str;
      description = "zsh prompt color";
      default = "blue";
    };

    nvimFull = mkOption {
      type = types.bool;
      description = "disable some neovim plugins etc.";
      default = false;
    };
  };
}
