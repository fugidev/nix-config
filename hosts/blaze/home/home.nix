{ flakeRoot, ... }:
{
  imports = [
    (flakeRoot + /modules/home/librewolf.nix)
  ];

  home.pointerCursor.size = 24;
  home.stateVersion = "22.05";
}
