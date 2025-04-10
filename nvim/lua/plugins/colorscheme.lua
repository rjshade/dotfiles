-- return {
--   {
--     "catppuccin/nvim",
--     name = "catppuccin",
--     priority = 1000,
--     config = function()
--       vim.cmd.colorscheme("catppuccin-mocha")
--     end,
--   },
-- }

return {
  'deparr/tairiki.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("tairiki")
  end,
}
