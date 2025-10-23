{ flakeRoot, ... }:
{
  imports = [
    (flakeRoot + /modules/home/home-fugi-darwin.nix)
  ];

  fugi.promptColor = "#f7ce46"; # yellow

  home.stateVersion = "24.05";

  programs.nh = {
    enable = true;
    flake = "/etc/nix-darwin";
  };
}
