{ pkgs, lib, inputs, flakeRoot, ... }:
let
  useFromUnstable = import (flakeRoot + /util/useFromUnstable.nix);
in
{
  imports = [
    ./options.nix
    ./zsh.nix
    ./tmux.nix
    ./upgrade-diff.nix
    ./locale.nix
    (useFromUnstable {
      pkgs = [ "lix" ];
    })
  ];

  # combined with hostname, determines fqdn
  networking.domain = lib.mkDefault "fugi.dev";

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
