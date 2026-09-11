local my_icons = require("my.icons")

local function format_each(fmt, tbl)
  return vim.tbl_map(function(d) return string.format(fmt, d) end, tbl)
end

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
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
          { "location", icon = my_icons.location, separator = { left = my_icons.separator.left } },
          { "progress", icon = my_icons.progress, separator = { right = my_icons.separator.right } },
        },
      },
    },
  },
}
