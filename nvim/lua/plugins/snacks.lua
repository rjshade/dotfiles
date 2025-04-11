return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  --@type snacks.Config
  opts = {
    --input = { enabled = true },
    --bigfile = { enabled = true },
    --indent = { enabled = true },
    --gitbrowse = { enabled = true },
    --picker = { enabled = true },
    statuscolumn = { enabled = true },
  },
  keys = {
    { "ff",         function() Snacks.picker.smart() end,    desc = "Smart Find Files" },
    { "fb",         function() Snacks.picker.buffers() end,  desc = "Buffers" },
    { "fg",         function() Snacks.picker.grep() end,     desc = "Grep" },
    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
  }
}
