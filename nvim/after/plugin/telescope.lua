local builtin = require('telescope.builtin')

vim.keymap.set('n', 'ff', builtin.find_files, {}) -- search files in current directory
vim.keymap.set('n', 'ft', builtin.git_files, {})  -- search files in current git repo
vim.keymap.set('n', 'fg', builtin.live_grep, {})  -- search inside files
vim.keymap.set('n', 'fb', builtin.buffers, {})    -- search open buffer file names
