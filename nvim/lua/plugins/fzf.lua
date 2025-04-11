return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- or if using mini.icons/mini.nvim
  -- dependencies = { "echasnovski/mini.icons" },
  opts = {},
  keys = {
    { "ft", function() require("fzf-lua").git_files() end, desc = "Find files in git repo" },
    { "ff", function() require("fzf-lua").files() end, desc = "Find files" },
    { "fb", function() require("fzf-lua").buffers() end, desc = "Buffers" },
    { "fg", function() require("fzf-lua").grep() end, desc = "Grep" },
    { "<leader>gd", function() require("fzf-lua").git_diff() end, desc = "Git Diff (Hunks)" },
  }
}
