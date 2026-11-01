return {
  {
    "neovim/nvim-lspconfig",
    opts = { ["basedpyright"] = true },
  },

  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      -- Oppia keeps runtime deps out of the venv (so mypy treats them as Any,
      -- like CI does); pylint still needs them, as in Oppia's own lint runner.
      table.insert(
        require("lint").linters.pylint.args,
        1,
        [[--init-hook=import os, sys; os.path.isdir("third_party/python_libs") and sys.path.append(os.path.abspath("third_party/python_libs"))]]
      )
      opts.python = { "mypy", "pylint" }
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { auto_install = { "python" } },
    opts_extend = { "auto_install" },
  },

  {
    "mfussenegger/nvim-dap-python",
    config = function() require("dap-python").setup("python3") end,
  },

  {
    "stevearc/conform.nvim",
    opts = { formatters_by_ft = { python = { "black" } } },
  },
}
