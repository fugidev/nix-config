{ config, pkgs, lib, ... }:
{
  imports = [
    ./options.nix
    ./tmux.nix
  ];

  # set zsh as default shell
  users.defaultUserShell = pkgs.zsh;

  # set time zone
  time.timeZone = "Europe/Berlin";

  # env variables
  environment.variables = {
    EDITOR = "nvim";
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
  ];

  # enable flake support
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}
