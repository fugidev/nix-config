{ pkgs, config, lib, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    extraConfig = ''
      set list                        " show whitespace
      set listchars=tab:!·,trail:·    " highlight tabs trailing spaces
      set number relativenumber       " hybrid line numbers

      let g:indentLine_char = '▏'     " set indentLine character to U+258F

      " lightline config
      let g:lightline = {
        \ 'colorscheme': 'powerlineish'
        \ }
      set noshowmode                  " hide default mode indicator
    '';

    extraPackages = with pkgs; [ ];

    plugins = with pkgs.vimPlugins; [
      vim-nix # nix syntax highlighting
      indentLine # visual line indentation
      lightline-vim # status line
    ];
  };
}
