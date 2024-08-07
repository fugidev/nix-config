{ config, pkgs, ... }:
let
  thisMachine = config.fugi.machines.${config.networking.hostName};
in
{
  imports = [
    ./options.nix
    ./machines.nix
    ./zsh.nix
    ./tmux.nix
    ./upgrade-diff.nix
    ./locale.nix
  ];

  networking = {
    inherit (thisMachine) domain;
  };

  # set time zone
  time.timeZone = "Europe/Berlin";

  # env variables
  environment.variables = rec {
    EDITOR = "hx";
    LESS = "-FSR";
    SYSTEMD_LESS = LESS;
  };

  programs.less = {
    enable = true;
    # horizontal scrolling in smaller steps instead of half page
    commands = {
      "\\eOD" = "noaction 20\\e(";
      "\\eOC" = "noaction 20\\e)";
    };
  };

  # system packages
  environment.systemPackages = with pkgs; [
    # neofetch # very essential
    fastfetch
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
    gptfdisk
    nmap
    pv
  ];

  nix = {
    # use lesbiab nix
    package = pkgs.lix;
    # enable flake support
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
