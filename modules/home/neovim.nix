{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;

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

    plugins = with pkgs.vimPlugins; [
      indent-blankline-nvim # visual line indentation
      lightline-vim # status line
      nvim-treesitter
    ];
  };
}
