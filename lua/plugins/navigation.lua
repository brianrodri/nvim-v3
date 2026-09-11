return {
  {
    "christoomey/vim-tmux-navigator",
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      picker = {
        enabled = true,
        hidden = true,
        sources = {
          files = { hidden = true },
          explorer = { hidden = true },
        },
      },
      notifier = { enabled = true },
      input = { enabled = true },
    },
  },
}
