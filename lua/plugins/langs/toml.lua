return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { auto_install = { "toml" } },
    opts_extend = { "auto_install" },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = { toml = { "taplo" } },
    },
  },
}
