local function runtime_format(fmt, inner)
  return function(buf) return string.format(fmt, inner(buf)) end
end

local function runtime_choice(opts)
  return function(buf)
    local choice = opts[1]
    if opts.error and buf.diagnostics.errors > 0 and vim.diagnostic.is_enabled() then
      choice = opts.error
    elseif opts.warning and buf.diagnostics.warnings > 0 and vim.diagnostic.is_enabled() then
      choice = opts.warning
    elseif opts.readonly and buf.is_readonly then
      choice = opts.readonly
    elseif opts.modified and buf.is_modified then
      choice = opts.modified
    elseif opts.focused and buf.is_focused then
      choice = opts.focused
    end
    if vim.is_callable(choice) then return choice(buf) end
    return choice
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
        readonly = hlgroups.get_hl_attr("DiagnosticInfo", "fg"),
      }
      local bg = {
        focused = hlgroups.get_hl_attr("ColorColumn", "bg"),
        unfocused = "NONE",
      }

      return {
        default_hl = {
          fg = runtime_choice({ fg.unfocused, focused = fg.focused }),
          bg = runtime_choice({ bg.unfocused, focused = bg.focused }),
        },

        components = {
          {
            text = runtime_choice({ " ", focused = my_icons.separators.left }),
            fg = bg.focused,
            bg = bg.unfocused,
          },
          {
            text = runtime_format(
              " %s",
              runtime_choice({
                function(buf) return buf.devicon.icon end,
                error = my_icons.diagnostics.error .. " ",
                warning = my_icons.diagnostics.warn .. " ",
                modified = my_icons.modified .. " ",
                readonly = my_icons.readonly .. " ",
              })
            ),
            fg = runtime_choice({
              function(buf) return buf.devicon.color end,
              error = fg.error,
              warning = fg.warning,
              modified = fg.warning,
              readonly = fg.readonly,
            }),
          },
          {
            text = function(buf) return buf.unique_prefix end,
            fg = fg.unfocused,
            italic = true,
            truncation = { direction = "left" },
          },
          {
            text = function(buf) return buf.filename end,
            fg = runtime_choice({
              error = fg.error,
              warning = fg.warning,
              modified = fg.warning,
              readonly = fg.readonly,
            }),
            truncation = { direction = "left" },
          },
          {
            text = string.format(" %s ", my_icons.close),
            on_click = function(_, _, _, _, buf) buf:delete() end,
          },
          {
            text = runtime_format("%s ", runtime_choice({ " ", focused = my_icons.separators.right })),
            fg = bg.focused,
            bg = bg.unfocused,
          },
        },
      }
    end,
  },
}
