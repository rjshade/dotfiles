return {
  {
    "mason-org/mason.nvim",
    dependencies = {
      "mason-org/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        automatic_installation = true,
        automatic_setup = true,
        ensure_installed = {
          "bashls",
          "clangd",
          "dockerls",
          "graphql",
          "html",
          "jsonls",
          "lua_ls",
          "pyright",
          "vimls",
          "zls"
        },
      })
    end,
  },
}
