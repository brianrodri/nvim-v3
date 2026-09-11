return {
  {
    "folke/trouble.nvim",
    -- NOTE: `auto_open` views are constructed during Trouble's own `setup`, so it cannot wait for
    -- `cmd = "Trouble"` — by the time a quickfix list exists there would be nothing listening.
    event = "VeryLazy",
    ---@module "trouble"
    ---@type trouble.Config
    opts = {
      modes = {
        -- Render the real quickfix list rather than `:h :copen`. The list stays the single source of
        -- truth, so Neovim's own `[q`/`]q` keep driving it and the default `follow` tracks the cursor
        -- they move. That leaves no reason for a `<leader>x` quickfix toggle: `auto_close` would shut
        -- an empty list again the moment it opened.
        qflist = { auto_open = true, auto_close = true },
        lsp = { win = { position = "right" } },
      },
    },
  },

  -- Supplies Trouble's `todo` mode (via its own `lua/trouble/sources/todo.lua`) and the in-buffer
  -- keyword highlighting behind `]t`/`[t`.
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {},
  },
}
