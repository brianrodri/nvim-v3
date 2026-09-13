local my_icons = require("my.icons")

local function format_each(fmt, tbl)
  return vim.tbl_map(function(d) return string.format(fmt, d) end, tbl)
end

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "folke/trouble.nvim",
    },
    -- A function so `trouble.statusline()` is built once, at config time: it registers listeners and
    -- caches its own rendering, so it must not be re-created per redraw.
    opts = function()
      -- The symbol path the cursor sits inside. Trouble renders it with its own highlights and
      -- joins one symbol to the next with an unhighlighted space, so it can only sit flush in a
      -- section that has no background of its own. `everforest` leaves `c` bare, and lualine draws
      -- `x` with the same groups -- hence `lualine_c_normal` for a component living in `x`.
      local symbols = require("trouble").statusline({
        mode = "symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{kind_icon}{symbol.name:Normal}",
        hl_group = "lualine_c_normal",
      })

      return {
        options = {
          theme = "everforest",
          globalstatus = true,
          component_separators = { left = "", right = "" },
          section_separators = my_icons.separators,
        },
        sections = {
          lualine_a = {
            { "mode", separator = my_icons.separators },
          },
          lualine_b = {},
          lualine_c = {
            { "filename", path = 1, icon = my_icons.file },
            { "branch", icon = my_icons.branch },
            { "diff", symbols = format_each("%s ", my_icons.git_symbols) },
          },
          lualine_x = {
            { "diagnostics", symbols = format_each("%s ", my_icons.diagnostics) },
            { symbols.get, cond = symbols.has },
            { "lsp_status", icon = my_icons.lsp },
          },
          lualine_y = {},
          lualine_z = {
            { "location", icon = my_icons.location, separator = { left = my_icons.separators.left } },
            { "progress", icon = my_icons.progress, separator = { right = my_icons.separators.right } },
          },
        },
      }
    end,
  },
}
