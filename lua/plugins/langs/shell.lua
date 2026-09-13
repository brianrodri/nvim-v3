return {
  {
    "neovim/nvim-lspconfig",
    opts = { ["bashls"] = true },
  },

  {
    "mfussenegger/nvim-lint",
    opts = { bash = { "shellcheck" } },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { auto_install = { "bash" } },
    opts_extend = { "auto_install" },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = { bash = { "shfmt" } },
    },
  },
}
