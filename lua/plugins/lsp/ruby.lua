return {
  {
    "neovim/nvim-lspconfig",
    opts = { ["ruby_lsp"] = true },
  },

  {
    "mfussenegger/nvim-lint",
    opts = { ruby = { "rubocop" } },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { auto_install = { "ruby" } },
    opts_extend = { "auto_install" },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = { ruby = { "prettier" } },
    },
  },
}
