return {
  {
    "neovim/nvim-lspconfig",
    opts = { ["rust_analyzer"] = true },
  },

  {
    "mfussenegger/nvim-lint",
    opts = { rust = { "clippy" } },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { auto_install = { "rust" } },
    opts_extend = { "auto_install" },
  },

  {
    "stevearc/conform.nvim",
    opts = { formatters_by_ft = { bash = { "rustfmt" } } },
  },
}
