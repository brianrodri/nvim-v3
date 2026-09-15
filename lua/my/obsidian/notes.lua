--- Actions for creating and finding notes in the vault.
---
--- Every function here is safe to bind directly to a key.
local M = {}
local H = {}

--- Creates a note and opens it.
function M.new()
  require("obsidian.actions").new(nil, function(note) note:open() end)
end

--- Picks a note by name, formatted the way snacks formats any file.
---
--- `obsidian.picker.find_notes` renders plain text rows, so this drives the `obsidian_files` snacks source
--- directly. That source knows nothing about obsidian's picker mappings, so they are re-attached here.
function M.find()
  local obsidian_picker = require("obsidian.picker")
  local opts = { win = { input = { keys = {} } }, actions = {} }

  H.attach(
    opts,
    obsidian_picker._note_selection_mappings(),
    function(_, item) return require("snacks.picker.util").path(item) end
  )
  H.attach(opts, obsidian_picker._note_query_mappings(), function(picker) return picker.input.filter.pattern end)

  require("snacks.picker").pick("obsidian_files", opts)
end

--- Picks a note by content.
---
--- `obsidian.picker.grep_notes` already drives snacks' native grep source, so it needs no help.
function M.grep() require("obsidian.picker").grep_notes() end

--- Opens today's daily note.
function M.open_daily() require("obsidian.daily").today():open() end

--- Binds obsidian's picker mappings onto a snacks pick spec.
---
---@param opts table the snacks pick spec to add `win.input.keys` and `actions` to.
---@param mappings obsidian.PickerMappingTable what to bind, keyed by left-hand side.
---@param argument fun(picker: table, item: table?): any resolves what the mapping's callback is given.
function H.attach(opts, mappings, argument)
  for lhs, mapping in pairs(mappings) do
    local name = "obsidian_" .. mapping.desc:gsub("%A", "_")
    opts.win.input.keys[lhs] = { name, mode = { "n", "i" }, desc = mapping.desc }
    opts.actions[name] = function(picker, item)
      local value = argument(picker, item)
      picker:close()
      vim.schedule(function() mapping.callback(value) end)
    end
  end
end

return M
