return {
  {
    "neovim/nvim-lspconfig",
    opts = { ["nixd"] = true },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = { nix = { "nixfmt" } },
    },
  },

  {
    "mfussenegger/nvim-lint",
    opts = { nix = { "statix", "deadnix" } },
  },
}
