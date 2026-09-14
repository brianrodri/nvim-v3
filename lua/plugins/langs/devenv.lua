return {
  {
    "neovim/nvim-lspconfig",
    opts = { ["nixd"] = true },
  },

  {
    "mfussenegger/nvim-lint",
    opts = { nix = { "statix", "deadnix" } },
  },

  {
    "stevearc/conform.nvim",
    opts = { formatters_by_ft = { nix = { "nixfmt" } } },
  },
}
