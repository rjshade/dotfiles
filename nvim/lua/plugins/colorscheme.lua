return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
}

--return {
--  'deparr/tairiki.nvim',
--  lazy = false,
--  priority = 1000,
--  config = function()
--    vim.cmd.colorscheme("tairiki")
--  end,
--}

--return {
--  'folke/tokyonight.nvim',
--  lazy = false,
--  priority = 1000,
--  config = function()
--    vim.cmd.colorscheme("tokyonight")
--  end,
--}

--return {
--  'loctvl842/monokai-pro.nvim',
--  lazy = false,
--  priority = 1000,
--  config = function()
--    require('monokai-pro').setup({
--      filter = 'machine',
--    })
--    vim.cmd.colorscheme("monokai-pro")
--  end,
--}

--return {
--  'rebelot/kanagawa.nvim',
--  lazy = false,
--  priority = 1000,
--  config = function()
--    vim.cmd.colorscheme("kanagawa")
--  end,
--}
