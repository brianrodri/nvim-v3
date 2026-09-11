local function with_format(fmt, inner)
  return function(buf) return string.format(fmt, inner(buf)) end
end

local function with_focus_alt(focus_alt, unfocused_alt)
  return function(buf) return buf.is_focused and focus_alt or unfocused_alt end
end

local function with_diagnostic_overrides(fallback, error_val, warning_val)
  return function(buf)
    if buf.diagnostics.errors > 0 then return error_val end
    if buf.diagnostics.warnings > 0 then return warning_val end
    if vim.is_callable(fallback) then return fallback(buf) end
    return fallback
  end
end

return {
  {
    "willothy/nvim-cokeline",
    dependencies = { "nvim-mini/mini.icons" },
    opts = function()
      local my_icons = require("my.icons")
      local hlgroups = require("cokeline.hlgroups")

      local fg = {
        focused = hlgroups.get_hl_attr("Normal", "fg"),
        unfocused = hlgroups.get_hl_attr("Comment", "fg"),
        error = hlgroups.get_hl_attr("DiagnosticError", "fg"),
        warning = hlgroups.get_hl_attr("DiagnosticWarn", "fg"),
      }
      local bg = {
        focused = hlgroups.get_hl_attr("ColorColumn", "bg"),
        unfocused = "NONE",
      }

      return {
        default_hl = {
          fg = with_focus_alt(fg.focused, fg.unfocused),
          bg = with_focus_alt(bg.focused, bg.unfocused),
        },

        components = {
          { text = with_focus_alt(my_icons.separator.left, " "), fg = bg.focused, bg = bg.unfocused },
          {
            text = with_diagnostic_overrides(
              function(buf) return buf.devicon.icon end,
              my_icons.diagnostics.error .. " ",
              my_icons.diagnostics.warn .. " "
            ),
            fg = with_diagnostic_overrides(function(buf) return buf.devicon.color end, fg.error, fg.warning),
          },
          {
            text = function(buf) return buf.unique_prefix end,
            fg = fg.unfocused,
            italic = true,
            truncation = { direction = "left" },
          },
          {
            text = function(buf) return buf.filename end,
            fg = with_diagnostic_overrides(fg.focused, fg.error, fg.warning),
            truncation = { direction = "left" },
          },
          {
            text = with_format(" %s", function(buf)
              if buf.is_readonly then return my_icons.readonly end
              if buf.is_modified then return my_icons.modified end
              return my_icons.close
            end),
            on_click = function(_, _, _, _, buf) buf:delete() end,
          },
          { text = with_focus_alt(my_icons.separator.right .. " ", "  "), fg = bg.focused, bg = bg.unfocused },
        },
      }
    end,
  },
}
