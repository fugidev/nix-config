{ lib, pkgs, machineConfig, ... }:
{
  imports = [
    ./options.nix
    ./zsh.nix
    ./tmux.nix
    ./upgrade-diff.nix
    ./locale.nix
  ];

  networking = {
    inherit (machineConfig) domain hostName;
  };

  # set time zone
  time.timeZone = "Europe/Berlin";

  # keymap
  console.keyMap = lib.mkDefault "de";

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

  programs.zsh = {
    shellAliases = {
      rebuild = "nixos-rebuild --log-format multiline --use-remote-sudo";
    };
    interactiveShellInit = ''
      nom-rebuild() {
        host="$(hostname)"
        if (( $# > 0 )); then
          host="$1"
          shift
        fi
        nom build .\#nixosConfigurations.$host.config.system.build.toplevel "$@"
      }
    '';
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
    smartmontools
    duf
    nix-output-monitor
  ];

  nix = {
    # use lesbiab nix
    package = pkgs.lix;
    # enable flake support
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  fugi.allowInsecure = [
    "dotnet-sdk-6.0.428" # for naps2
  ];
}
