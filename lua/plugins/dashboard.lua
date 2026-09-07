return {
  {
    "folke/snacks.nvim",
    opts = function()
      local my_braille_art = require("my.braille-art")
      my_braille_art.set_palette_highlights()
      return {
        dashboard = {
          sections = {
            { text = my_braille_art.get_text_definition(), align = "center", padding = 2 },
            { section = "keys", icon = "󰌌 ", indent = 2, padding = 1 },
            { section = "recent_files", icon = "󱋡 ", indent = 2, padding = 1, title = "Recent Files", cwd = true },
            { section = "projects", icon = " ", indent = 2, padding = 1, title = "Recent Projects" },
            { section = "startup" },
          },
          preset = {
            keys = {
              { icon = "󰝒 ", key = "n", desc = "New File", action = ":enew" },
              { icon = "󰱼 ", key = "f", desc = "Find File", action = "<leader>ff" },
              { icon = "󱋡 ", key = "r", desc = "Find Recent", action = "<leader>fr" },
              { icon = "󱁻 ", key = "c", desc = "Find Config", action = "<leader>fc" },
              { icon = "󰇈 ", key = "v", desc = "Open Daily Note", action = "<leader>vt" },
              { icon = "󱎸 ", key = "/", desc = "Find Pattern", action = "<leader>f/" },
              { icon = " ", key = "g", desc = "Lazygit", action = "<leader>gg" },
              { icon = "󰒲 ", key = "l", desc = "Lazy", action = "<leader>ll" },
              { icon = " ", key = "q", desc = "Quit", action = "<leader>qq" },
            },
          },
        },
      }
    end,
  },
}
