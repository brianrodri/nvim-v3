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
        -- Sends the current results into Trouble, so a grep can become a persistent list.
        actions = {
          trouble_open = function(...) return require("trouble.sources.snacks").actions.trouble_open.action(...) end,
        },
        win = {
          input = { keys = { ["<a-t>"] = { "trouble_open", mode = { "n", "i" } } } },
        },
      },
      notifier = { enabled = true },
      input = { enabled = true },
    },
  },
}
