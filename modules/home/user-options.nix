{ lib, pkgs, ... }: with lib; {
  options.fugi = {
    wallpaper = mkOption {
      type = types.path;
      description = "desktop and lockscreen background";
      default = pkgs.fetchurl {
        url = "https://web.archive.org/web/20230404203951if_/https://images.wallpapersden.com/image/download/macos-12-monterey-digital_bG1mZ2mUmZqaraWkpJRpbW5trWlpamc.jpg";
        sha256 = "NA4nhCcnT6B9IJQWh8ldnjSt9eUFmte6AfN3cNz8Fwk=";
      };
    };

    guiApps = mkOption {
      type = types.bool;
      description = "install gui applications";
      default = false;
    };
  };
}
