{ pkgs, config, lib, ... }:
with pkgs; {
  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      #coc.enable = true;

      extraConfig = ''
      '';

      extraPackages = with pkgs; [];

      plugins = with pkgs.vimPlugins; [
        vim-nix
      ];
    };
  };
}
