-- Helpers
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end


-- Icons
require('nvim-web-devicons').setup { default = true }

-- Completion/Snippets
local cmp = require('cmp')
local lspkind = require('lspkind')
local luasnip = require('luasnip')
luasnip.config.set_config {
    enable_autosnippets = true,
}

require('snippets')

cmp.setup {
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),

    ['<Tab>'] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif cmp.visible() then
        cmp.select_next_item()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      elseif cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' }
  }, {
    {
      name = 'buffer',
      option = {
        keyword_pattern = [[\k\+]], -- allow unicode multibyte characters
      },
    }
  }),
  formatting = {
    format = lspkind.cmp_format({
      with_text = false,
      maxwidth = 50,
    })
  },
}


-- LSP
local lsp = require('lspconfig')

lsp.rnix.setup {}

lsp.rust_analyzer.setup {
  settings = {
    ['rust-analyzer'] = {},
  },
  capabilities = require("cmp_nvim_lsp").default_capabilities()
}

-- Tree Sitter
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
}

-- indent-blankline
require("indent_blankline").setup {
  char = "▏",
  char_blankline = "",
  space_char_blankline = "",
  show_first_indent_level = false,
  use_treesitter = true,
}
vim.cmd('highlight IndentBlanklineChar ctermfg=239') -- darker grey
