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

--{
--	  "folke/snacks.nvim",
--  lazy = false,
-- --@type snacks.Config
--  opts = {
--    input = { enabled = true },
--    bigfile = { enabled = true },
--    indent = { enabled = true },
--    explorer = { enabled = true },
--    gitbrowse = { enabled = true },
--  },
--  --opts = {
--  --  -- your configuration comes here
--  --  -- or leave it empty to use the default settings
--  --  -- refer to the configuration section below
--  --  notifier = { enabled = true },
--  --  quickfile = { enabled = true },
--  --  scope = { enabled = true },
--  --  statuscolumn = { enabled = true },
--  --  words = { enabled = true },
--  --},
--
-- },
'mhinz/vim-signify',              -- Shows git status in sidebar.
'tpope/vim-commentary',           -- Comment/uncomment easily.
'tpope/vim-fugitive',             -- Git commands in vim.
'nvim-lua/plenary.nvim',          -- Needed for telescope.nvim.
{ import = "plugins.telescope" }, -- Fuzzy file finder.
'williamboman/mason.nvim',        -- LSP installation
'williamboman/mason-lspconfig.nvim',
'neovim/nvim-lspconfig',          -- Easy config for LSP.
'github/copilot.vim',             -- Github's copilot code completion.
'jparise/vim-graphql',            -- GraphQL syntax highlighting.
'kyazdani42/nvim-web-devicons',   -- for file icons
'kyazdani42/nvim-tree.lua',       -- for file tree
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
  { import = "plugins.colorscheme" }
})
