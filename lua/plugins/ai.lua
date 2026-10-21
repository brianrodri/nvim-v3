local FRAC_1_PHI = 2.0 / (1.0 + math.sqrt(5.0))

return {
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat", "CodeCompanionHistory" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/codecompanion-history.nvim",
      "lalitmee/codecompanion-spinners.nvim",
    },
    opts = {
      interactions = {
        chat = {
          adapter = "claude_code",
          slash_commands = {
            -- Without this, the provider auto-detection picks mini.pick ahead of snacks.
            buffer = { opts = { provider = "snacks" } },
            file = { opts = { provider = "snacks" } },
            help = { opts = { provider = "snacks" } },
            symbols = { opts = { provider = "snacks" } },
          },
        },
        inline = { adapter = "claude_code" },
      },
      display = {
        action_palette = { provider = "snacks" },
        -- Layout and position are set from the terminal's shape by `my.codecompanion`.
        chat = { window = { width = 1.0 - FRAC_1_PHI, height = 1.0 - FRAC_1_PHI } },
      },
      extensions = {
        history = {
          enabled = true,
          -- Title generation rejects ACP adapters, and there is no HTTP adapter to delegate to.
          opts = { picker = "snacks", auto_save = true, auto_generate_title = false },
        },
        spinner = { opts = { style = "snacks" } },
      },
    },
    config = function(_, opts)
      require("codecompanion").setup(opts)
      local my_codecompanion = require("my.codecompanion")
      my_codecompanion.update_chat_window()
      vim.api.nvim_create_autocmd("VimResized", {
        group = vim.api.nvim_create_augroup("MyCodeCompanionChatWindow", { clear = true }),
        desc = "Place the CodeCompanion chat window according to the terminal's shape",
        callback = my_codecompanion.update_chat_window,
      })
    end,
  },
}
