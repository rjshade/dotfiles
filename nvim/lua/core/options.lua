vim.g.mapleader     = ','
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

-- Fold
vim.o.foldenable = true
vim.o.foldexpr = 'v:lua.vim.lsp.foldexpr()'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldmethod = 'expr'

-- Highlight on yank
local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand
augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
  group = 'YankHighlight',
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = '150', on_visual = true })
  end
})
