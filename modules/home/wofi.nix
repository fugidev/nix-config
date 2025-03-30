{ pkgs, ... }:
let
  wofi-arc-dark = pkgs.fetchurl {
    url = "https://codeberg.org/fugi/wofi-arc-dark/raw/commit/982aa53280d65c291ff7ab38b309903b7aa57dda/style.css";
    hash = "sha256-e7UBadTBXiYQPdEet0toE8ck8UD/U1dpLAtqgB+dpJI=";
  };
in
{
  programs.wofi = {
    enable = true;

    settings = {
      allow_images = true;
      image_size = 20;
      width = 1000;
      insensitive = true;
      matching = "multi-contains";
    };

    style = (builtins.readFile wofi-arc-dark) + ''
      #window {
        background-color: rgba(45, 48, 59, 0.7);
      }
      #entry {
        background-color: rgba(45, 48, 59, 0.5);
      }
    '';
  };
}
