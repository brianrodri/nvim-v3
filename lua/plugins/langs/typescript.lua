--- Returns the git root if `bufnr` is in my work repo (any clone or worktree of it).
local function work_repo_root(bufnr)
  local git_root = vim.fs.root(bufnr, ".git")
  if not git_root then return nil end
  local json_path = string.format("%s/package.json", git_root)
  local ok, pkg = pcall(function() return vim.json.decode(vim.iter(vim.fn.readfile(json_path)):join("\n")) end)
  if ok and pkg.name == "stepful" then return git_root end
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local ts_ls = dofile(vim.api.nvim_get_runtime_file("lsp/ts_ls.lua", false)[1])
      opts["ts_ls"] = vim.tbl_deep_extend("force", ts_ls, {
        root_dir = function(bufnr, on_dir)
          if work_repo_root(bufnr) then ts_ls.root_dir(bufnr, on_dir) end
        end,
      })
      local tsc = dofile(vim.api.nvim_get_runtime_file("lsp/tsc.lua", false)[1])
      opts["tsc"] = vim.tbl_deep_extend("force", tsc, {
        root_dir = function(bufnr, on_dir)
          if not work_repo_root(bufnr) then tsc.root_dir(bufnr, on_dir) end
        end,
      })
    end,
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
