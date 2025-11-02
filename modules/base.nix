{ lib, machineConfig, ... }:
{
  imports = [
    ./options.nix
    ./base-packages.nix
    ./zsh
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

  # keep LESS for e.g. `sudo -u postgres psql`
  security.sudo.extraConfig = ''
    Defaults:root,%wheel env_keep+=LESS
  '';

  programs.bat = {
    enable = true;
    settings = {
      theme = "TwoDark";
      style = "plain";
    };
  };

  programs.zsh = {
    interactiveShellInit = ''
      nom-rebuild() {
        host="$(hostname)"
        if (( $# > 0 )); then
          host="$1"
          shift
        fi
        nom build .\#nixosConfigurations.$host.config.system.build.toplevel "$@"
        nix copy -v --to ssh://$host .\#nixosConfigurations.$host.config.system.build.toplevel
      }
    '';
  };

  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
  };

  nix = {
    # enable flake support
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    settings = {
      substituters = lib.optionals (machineConfig.hostName != "cleric") [
        "https://cache.fugi.dev"
      ];
      trusted-public-keys = lib.optionals (machineConfig.hostName != "cleric") [
        "cache.fugi.dev:0zmYYGJ0D5p1TWe4FomYGb+tGEHQ7hpbbDudeKXt0rs="
      ];
    };
  };
}
