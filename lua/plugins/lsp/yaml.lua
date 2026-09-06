return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { auto_install = { "yaml" } },
    opts_extend = { "auto_install" },
  },

  {
    "mfussenegger/nvim-lint",
    opts = { yaml = { "yamllint" } },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = { yaml = { "yamlfmt" } },
    },
  },
}
