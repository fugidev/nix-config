{ config, pkgs, lib, ... }: {
  # set time zone
  time.timeZone = "Europe/Berlin";

  # system packages
  environment.systemPackages = with pkgs; [
    neofetch # very essential
    git
    htop
    btop
    bat
    fd
    nixpkgs-fmt
    exa
  ];

  # enable flake support
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}
