return {
  { "tpope/vim-sleuth" },

  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    ---@module "nvim-surround"
    ---@type user_options
    opts = { move_cursor = "sticky" },
  },

  -- Supplies the `textobjects.scm` queries behind the `]f`/`]c` motions bound in `config.keys`.
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = { move = { set_jumps = true } },
  },
}
