return {
  {
    "neovim/nvim-lspconfig",
    opts = { ["ts_ls"] = true },
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      javascript = { "eslint" },
      javascriptreact = { "eslint" },
      typescript = { "eslint" },
      typescriptreact = { "eslint" },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { auto_install = { "tsx", "typescript" } },
    opts_extend = { "auto_install" },
  },

  { "mxsdev/nvim-dap-vscode-js" },

  {
    "nvim-neotest/neotest",
    dependencies = { "nvim-neotest/neotest-jest" },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      table.insert(opts.adapters, require("neotest-jest")({ jestCommand = "npx jest" }))
      return opts
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
      },
    },
  },
}
