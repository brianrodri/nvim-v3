local my_icons = require("my.icons")

local function format_each(fmt, tbl)
  return vim.tbl_map(function(d) return string.format(fmt, d) end, tbl)
end

return {
  {
    "nvim-lualine/lualine.nvim",
    -- A function so `trouble.statusline()` is built once, at config time: it registers listeners and
    -- caches its own rendering, so it must not be re-created per redraw.
    opts = function()
      -- Replaces the cursor `location` with the symbol path the cursor sits inside. `has()` is false
      -- outside a symbol, which is when `progress` below stands alone.
      local symbols = require("trouble").statusline({
        mode = "symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{kind_icon}{symbol.name:Normal}",
        hl_group = "lualine_z_normal",
      })

      return {
        options = {
          theme = "everforest",
          globalstatus = true,
          component_separators = { left = "", right = "" },
          section_separators = my_icons.separator,
        },
        sections = {
          lualine_a = {
            { "mode", separator = my_icons.separator },
          },
          lualine_b = {},
          lualine_c = {
            { "filename", path = 1, icon = my_icons.file },
            { "branch", icon = my_icons.branch },
            { "diff", symbols = format_each("%s ", my_icons.git_symbols) },
          },
          lualine_x = {
            { "diagnostics", symbols = format_each("%s ", my_icons.diagnostics) },
            { "lsp_status", icon = my_icons.lsp },
          },
          lualine_y = {},
          lualine_z = {
            { symbols.get, cond = symbols.has, separator = { left = my_icons.separator.left } },
            {
              "progress",
              icon = my_icons.progress,
              separator = { left = my_icons.separator.left, right = my_icons.separator.right },
            },
          },
        },
      }
    end,
  },
}
