return {
  {
    "folke/snacks.nvim",
    opts = function()
      local my_braille_art = require("my.braille-art")
      local my_icons = require("my.icons")
      return {
        dashboard = {
          sections = {
            { text = my_braille_art.render_text(), align = "center", padding = 2 },
            { section = "keys", icon = my_icons.keymaps .. " ", indent = 2, padding = 1 },
            {
              section = "recent_files",
              icon = my_icons.recent .. " ",
              indent = 2,
              padding = 1,
              title = "Recent Files",
              cwd = true,
              limit = 3,
            },
            {
              section = "projects",
              icon = my_icons.projects .. " ",
              indent = 2,
              padding = 1,
              title = "Recent Projects",
              limit = 3,
            },
            { section = "startup" },
          },
          preset = {
            keys = {
              { icon = my_icons.new_file .. " ", key = "n", desc = "New File", action = ":enew" },
              { icon = my_icons.find_file .. " ", key = "f", desc = "Find File", action = "<leader>ff" },
              { icon = my_icons.find_text .. " ", key = "/", desc = "Find Pattern", action = "<leader>f/" },
              { icon = my_icons.git .. " ", key = "g", desc = "Lazygit", action = "<leader>g" },
              { icon = my_icons.lazy .. " ", key = "l", desc = "Lazy", action = "<leader>l" },
              { icon = my_icons.quit .. " ", key = "q", desc = "Quit", action = "<leader>q" },
            },
          },
        },
      }
    end,
  },
}
