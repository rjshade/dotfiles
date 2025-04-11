require("core")
require("plugins")

local local_config = vim.fn.expand('~/.config/local/nvim/local.lua')
if vim.fn.filereadable(local_config) == 1 then
  vim.cmd('source ' .. local_config)
end

vim.cmd.colorscheme('Tomorrow-Night')
