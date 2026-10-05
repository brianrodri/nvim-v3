return {
  { "tpope/vim-sleuth" },

  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    ---@module "nvim-surround"
    ---@type user_options
    opts = { move_cursor = "sticky" },
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = { move = { set_jumps = true } },
  },

  {
    "nvim-mini/mini.operators",
    event = "VeryLazy",
    opts = {
      exchange = { prefix = "gs", reindent_linewise = true },
      evaluate = { prefix = "" },
      multiply = { prefix = "" },
      replace = { prefix = "" },
      sort = { prefix = "" },
    },
  },

  {
    "ThePrimeagen/refactoring.nvim",
    lazy = true,
    dependencies = { "lewis6991/async.nvim" },
    opts = {},
  },

  {
    "MagicDuck/grug-far.nvim",
    ---@module "grug"
    ---@type grug.far.OptionsOverride
    opts = { headerMaxWidth = 80 },
  },
}
