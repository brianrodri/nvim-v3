return {
  {
    "stevearc/conform.nvim",
    opts = {
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    },
    init = function() vim.o.formatexpr = 'v:lua.require"conform".formatexpr()' end,
  },
}
