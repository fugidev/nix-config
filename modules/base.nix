{ config, pkgs, lib, ... }:
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
    xdg-utils
    jq
  ];

  # enable flake support
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}
