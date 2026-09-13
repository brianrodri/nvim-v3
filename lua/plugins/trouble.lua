return {
  {
    "folke/trouble.nvim",
    event = "VeryLazy",
    ---@module "trouble"
    ---@type trouble.Config
    opts = {
      modes = {
        qflist = { auto_open = true, auto_close = true },
        lsp = { win = { position = "right" } },
      },
    },
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {
      highlight = {
        pattern = [[.*<((KEYWORDS)%(\([^)]*\))?)\s*:]],
      },
      search = {
        pattern = [[\b(KEYWORDS)(\([^)]*\))?:]],
      },
    },
  },
}
