{ config, pkgs, lib, inputs, ... }:
let
  # build fd without jemalloc on asahi, doesn't support 16K pages
  fd =
    if (config.hardware ? "asahi") then
      pkgs.fd.overrideAttrs
        (_: {
          buildNoDefaultFeatures = true;
          buildFeatures = [ "completions" ];
        })
    else pkgs.fd;
in
{
  imports = [
    ./options.nix
    ./tmux.nix
    ./upgrade-diff.nix
  ];

  # set zsh as default shell
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

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
    exa
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
  ];

  # enable flake support
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  # speed up nix shell/run
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
}
