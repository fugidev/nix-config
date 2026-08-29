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

  nixpkgs.config.allowUnfreePackages = [
    "steam"
    "steam-unwrapped"
  ];
}
