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
    nixosZshConfig = import ../zsh args;
    extraConfig = {
      initContent = ''
        source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      '';
    };
  in
  {
    imports = [
      # for whatever reason, some options are named differently, so we have to alias them
      (lib.mkAliasOptionModule [ "programs" "zsh" "interactiveShellInit" ] [ "programs" "zsh" "initContent" ])
      (lib.mkAliasOptionModule [ "programs" "zsh" "promptInit" ] [ "programs" "zsh" "initContent" ])
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
