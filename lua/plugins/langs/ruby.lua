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
    opts = { formatters_by_ft = { ruby = { "prettier" } } },
  },

  {
    "nvim-neotest/neotest",
    dependencies = { "zidhuss/neotest-minitest" },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      table.insert(
        opts.adapters,
        require("neotest-minitest")({
          -- Neovim drops $VIM from pty jobs; minitest-reporters needs it to fall back to the stock reporter the adapter parses.
          test_cmd = { "env", "VIM=" .. vim.env.VIM, "bundle", "exec", "ruby", "-Itest" },
        })
      )
      return opts
    end,
  },
}
