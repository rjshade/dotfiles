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
vim.keymap.set('n', 'gR', function() vim.lsp.buf.rename() end)

vim.keymap.set('n', '<leader>F', function() vim.lsp.buf.format() end)

-- File navigation
vim.keymap.set('n', '<leader>a', ':ClangdSwitchSourceHeader<CR>')
