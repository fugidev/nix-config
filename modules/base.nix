{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    ./options.nix
    ./zsh.nix
    ./tmux.nix
    ./upgrade-diff.nix
  ];

  # combined with hostname, determines fqdn
  networking.domain = lib.mkDefault "fugi.dev";

  # set time zone
  time.timeZone = "Europe/Berlin";

  # env variables
  environment.variables = {
    EDITOR = "hx";
  };

  # system packages
  environment.systemPackages = with pkgs; [
    neofetch # very essential
    hyfetch
    git
    htop
    btop
    bat
    fd
    nixpkgs-fmt
    eza
    ripgrep
    wget
    neovim
    dig
    doggo
    xdg-utils
    jq
    file
    pciutils
    usbutils
    ncdu
    helix
    traceroute
  ];

  # compatibility for NixOS 23.05
  nixpkgs.overlays = [
    (
      self: super:
        {
          eza = lib.attrByPath [ "eza" ] super.exa super;
        }
    )
  ];

  # enable flake support
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  # speed up nix shell/run
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
}
