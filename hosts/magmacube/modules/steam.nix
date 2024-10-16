{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    extraPackages = with pkgs; [
      gamescope
      mangohud
    ];
  };

  fugi.allowUnfree = [
    "steam"
    "steam-original"
    "steam-run"
  ];
}
