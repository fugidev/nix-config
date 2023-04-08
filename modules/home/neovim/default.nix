# a lot of this is stolen from https://git.sbruder.de/simon/nixos-config
{ pkgs, config, lib, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    extraConfig = ''
      set list                        " show whitespace
      set listchars=tab:!·,trail:·    " highlight tabs trailing spaces
      set number relativenumber       " hybrid line numbers
      set expandtab shiftwidth=2      " 2 spaces indent

      " lightline config
      let g:lightline = {
        \ 'colorscheme': 'powerlineish'
        \ }
      set noshowmode                  " hide default mode indicator
    '';

    extraLuaConfig = lib.mkIf config.fugi.nvimFull (builtins.readFile ./init.lua);

    extraPackages = with pkgs; [
      #
    ] ++ (lib.optionals config.fugi.nvimFull [
      # lsp
      rust-analyzer
      rnix-lsp
    ]);

    plugins = with pkgs.vimPlugins; [
      #vim-nix # nix syntax highlighting
      indent-blankline-nvim # visual line indentation
      lightline-vim # status line
      nvim-treesitter
    ] ++ (lib.optionals config.fugi.nvimFull [
      cmp-nvim-lsp
      cmp-path
      cmp-buffer
      cmp_luasnip
      lspkind-nvim
      luasnip
      nvim-lspconfig
      nvim-cmp
      nvim-web-devicons
    ]);
  };

  xdg.configFile = {
    "nvim/lua/snippets.lua".source = pkgs.callPackage ./snippets.nix { };
  } // (lib.mapAttrs'
    (name: path: lib.nameValuePair "nvim/parser/${lib.removePrefix "tree-sitter-" name}.so" { source = "${path}/parser"; })
    ({
      inherit (pkgs.tree-sitter.builtGrammars)
        tree-sitter-c
        tree-sitter-cpp
        tree-sitter-css
        tree-sitter-html
        tree-sitter-json
        tree-sitter-lua
        tree-sitter-nix
        tree-sitter-python
        tree-sitter-rust
        tree-sitter-scss
        tree-sitter-toml
        tree-sitter-yaml;
    }));
}
