vim.g.mapleader = ','
require("plugins")

vim.opt.expandtab   = true    -- Turn tabs into spaces.
vim.opt.mouse       = 'a'     -- Mouse enabled all the time.
vim.opt.number      = true    -- Line numbers on
vim.opt.scrolloff   = 10      -- Keep 5 context lines around cursor.
vim.opt.shiftwidth  = 2       -- tab == 2 spaces.
vim.opt.showmatch   = true    -- Highlight matching braces.
vim.opt.ignorecase  = true    -- Case insensitive search...
vim.opt.smartcase   = true    -- ...unless search term has uppercase.
vim.opt.smartindent = true
vim.opt.softtabstop = 2       -- Make spaces feel like tabs.
vim.opt.tabstop     = 2       -- tab == 2 spaces.
vim.opt.title       = true    -- Terminal title.
vim.opt.undolevels  = 100000  -- Set a bigger undo history.

vim.keymap.set('n', ';', ':') -- Pressing shift is too much work

-- Ctrl + hjkl to move between split windows.
vim.keymap.set('n', '<C-h>', '<C-W>h', { noremap = true })
vim.keymap.set('n', '<C-j>', '<C-W>j', { noremap = true })
vim.keymap.set('n', '<C-k>', '<C-W>k', { noremap = true })
vim.keymap.set('n', '<C-l>', '<C-W>l', { noremap = true })

-- Move up and down using visual lines rather than actual lines.
vim.keymap.set('n', 'j', 'gj', { noremap = true })
vim.keymap.set('n', 'k', 'gk', { noremap = true })

-- LSP shortcuts.
vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end)
vim.keymap.set('n', 'gr', function() vim.lsp.buf.references() end)
vim.keymap.set('n', 'gh', function() vim.lsp.buf.hover() end)
vim.keymap.set('n', 'gc', function() vim.lsp.buf.code_action() end)
vim.keymap.set('n', 'gf', function() vim.lsp.buf.format() end)

local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand
-- Highlight on yank
augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
  group = 'YankHighlight',
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = '150', on_visual = true })
  end
})

-- Remove trailing whitespace on save
--vim.api.nvim_create_autocmd('BufWritePre', {
--  pattern = { '*' },
--  command = [[%s/\s\+$//e]],
--})


require("mason").setup {
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
}
require('mason-lspconfig').setup {
  ensure_installed = {
    'bashls',
    'clangd',
    'dockerls',
    'graphql',
    'html',
    'jsonls',
    'lua_ls',
    'pyright',
    'ts_ls',
    'vimls',
    'zls'
  }
}

require 'mason-lspconfig'.setup_handlers {
  function(server_name) -- default handler (optional)
    require 'lspconfig'[server_name].setup {}
  end,

  ['lua_ls'] = function()
    require 'lspconfig'.lua_ls.setup {
      settings = {
        Lua = {
          format = {
            enable = true,
            defaultConfig = {
              indent_style = "space",
              indent_size = "2",
              max_line_length = "90",
            },
          },
          diagnostics = {
            globals = { "vim" }
          }
        },
      },
    }
  end
}
vim.keymap.set('n', '<leader>F', function() vim.lsp.buf.format() end)

-- File navigation
vim.keymap.set('n', '<leader>a', ':ClangdSwitchSourceHeader<CR>')

local local_config = vim.fn.expand('~/.config/local/nvim/local.lua')
if vim.fn.filereadable(local_config) == 1 then
  vim.cmd('source ' .. local_config)
end

vim.diagnostic.config({
  float = {
    source = 'always',
    border = 'rounded',
  },
})

vim.o.fillchars = 'eob: ,fold: ,foldopen:,foldsep: ,foldclose:'
vim.o.foldcolumn = '2'
vim.o.foldenable = true
vim.o.foldexpr = 'v:lua.vim.lsp.foldexpr()'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldmethod = 'expr'
