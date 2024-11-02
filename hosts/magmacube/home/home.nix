{ pkgs, ... }:
{
  fugi.wallpaper = pkgs.fetchurl {
    url = "https://web.archive.org/web/20230404203951if_/https://images.wallpapersden.com/image/download/macos-12-monterey-digital_bG1mZ2mUmZqaraWkpJRpbW5trWlpamc.jpg";
    sha256 = "NA4nhCcnT6B9IJQWh8ldnjSt9eUFmte6AfN3cNz8Fwk=";
  };

  home.pointerCursor.size = 28;
  home.stateVersion = "24.05";
}
