local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
'mhinz/vim-signify',              -- Shows git status in sidebar.
'tpope/vim-commentary',           -- Comment/uncomment easily.
'tpope/vim-fugitive',             -- Git commands in vim.
'nvim-lua/plenary.nvim',          -- Needed for telescope.nvim.
'nvim-telescope/telescope.nvim',  -- Fuzzy file finder.
'williamboman/mason.nvim',        -- LSP installation
'williamboman/mason-lspconfig.nvim',
'neovim/nvim-lspconfig',          -- Easy config for LSP.
'github/copilot.vim',             -- Github's copilot code completion.
'jparise/vim-graphql',            -- GraphQL syntax highlighting.
'kyazdani42/nvim-web-devicons',   -- for file icons
'kyazdani42/nvim-tree.lua',       -- for file tree
})
