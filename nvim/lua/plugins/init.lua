local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable",
    lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  'mhinz/vim-signify',     -- Shows git status in sidebar.
  'tpope/vim-commentary',  -- Comment/uncomment easily.
  'tpope/vim-fugitive',    -- Git commands in vim.
  'neovim/nvim-lspconfig', -- Easy config for LSP.
  'github/copilot.vim',    -- Github's copilot code completion.
  'jparise/vim-graphql',   -- GraphQL syntax highlighting.
  { import = "plugins.mason" },
  { import = "plugins.snacks" },
  { import = "plugins.fzf" },
})
