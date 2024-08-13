{ config, lib, pkgs, ... }@args:

if (args ? "nixosConfig") then
# home-manager as nixos module, main zsh config is done system wide
  {
    programs.zsh = {
      enable = true;
    };
  }
else
# standalone home-manager, import the nixos module
  let
    nixosZshConfig = import ../zsh.nix args;
    extraConfig = {
      shellAliases = {
        dco = "docker compose";
        dcb = "docker compose build";
        dcdn = "docker compose down";
        dce = "docker compose exec";
        dcl = "docker compose logs";
        dclf = "docker compose logs -f";
        dcps = "docker compose ps --format 'table {{.Name}}\\t{{.Image}}\\t{{.Service}}\\t{{.RunningFor}}\\t{{.Status}}\\t{{.Ports}}'";
        dcpull = "docker compose pull";
        dcrestart = "docker compose restart";
        dcrm = "docker compose rm";
        dcstart = "docker compose start";
        dcstop = "docker compose stop";
        dcup = "docker compose up";
        dcupb = "docker compose up --build";
        dcupdb = "docker compose up -d --build";
        dcupd = "docker compose up -d";
        dtop = "docker top";
        dps = "docker ps --format 'table {{.ID}}\\t{{.Names}}\\t{{.Image}}\\t{{.RunningFor}}\\t{{.Status}}'";
        hms = "home-manager switch";
      };
      initExtra = ''
        source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      '';
    };
  in
  {
    imports = [
      # for whatever reason, some options are named differently, so we have to alias them
      (lib.mkAliasOptionModule [ "programs" "zsh" "interactiveShellInit" ] [ "programs" "zsh" "initExtra" ])
      (lib.mkAliasOptionModule [ "programs" "zsh" "promptInit" ] [ "programs" "zsh" "initExtra" ])
      (lib.mkAliasOptionModule [ "programs" "zsh" "shellInit" ] [ "programs" "zsh" "envExtra" ])
      (lib.mkAliasOptionModule [ "programs" "zsh" "autosuggestions" ] [ "programs" "zsh" "autosuggestion" ])
    ];

    inherit (nixosZshConfig) options;

    config = {
      programs.zsh = lib.mkMerge [
        nixosZshConfig.config.programs.zsh
        extraConfig
      ];

      home.packages = [ pkgs.fzf ];
    };
  }
