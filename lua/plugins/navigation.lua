return {
  {
    -- https://github.com/christoomey/vim-tmux-navigator/blob/e41c431a0c7b7388ae7ba341f01a0d217eb3a432/README.md?plain=1#L58-L81
    "christoomey/vim-tmux-navigator",
    -- The default terminal-mode mappings use Vim's `<C-w>:`, which Neovim types into the terminal (e.g. lazygit).
    init = function() vim.g.tmux_navigator_no_mappings = 1 end,
    keys = {
      { "<c-h>", "<cmd>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>" },
    },
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
        actions = {
          ---@diagnostic disable-next-line: undefined-field
          trouble_open = function(...) return require("trouble.sources.snacks").actions.trouble_open.action(...) end,
        },
        win = {
          input = { keys = { ["<C-X>"] = { "trouble_open", mode = { "n", "i" } } } },
        },
      },
      notifier = { enabled = true },
      input = { enabled = true },
    },
  },
}
