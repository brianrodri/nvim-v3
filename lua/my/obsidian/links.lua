---@module 'obsidian'

--- Actions for cross-linking notes into a `Broader`/`Narrower` hierarchy.
---
--- Every function here is safe to bind directly to a key.
local M = {}
local H = {}

--- Creates a note one step narrower than the current one, and cross-links the two.
function M.make_narrower() H.cross_reference("create", "Narrower") end

--- Creates a note one step broader than the current one, and cross-links the two.
function M.make_broader() H.cross_reference("create", "Broader") end

--- Cross-links an existing note as one step narrower than the current one.
function M.pick_narrower() H.cross_reference("picker", "Narrower") end

--- Cross-links an existing note as one step broader than the current one.
function M.pick_broader() H.cross_reference("picker", "Broader") end

--- Cross-links the current note with another note, then jumps to the new link in the other note.
---
--- The other note is created or picked according to `resolve`. The current note gains a link to it under
--- `header`, and it gains a link back to the current note under the opposing header.
---
---@param resolve "create"|"picker" how the other note is chosen.
---@param header "Broader"|"Narrower" the header in the current note that the other note is linked under.
function H.cross_reference(resolve, header)
  local back_header = header == "Broader" and "Narrower" or "Broader"

  local here = require("obsidian.api").current_note(0)
  if not here then return end

  H.resolve_note(resolve, function(there)
    if not there or tostring(there.path) == tostring(here.path) then return end
    here:insert_text(H.link_item(there), { section = header })
    local line = there:insert_text(H.link_item(here), { section = back_header })
    vim.fn.settagstack(0, { items = { { tagname = here:display_name(), from = vim.fn.getpos(".") } } }, "t")
    there:open({ line = line, col = 0 })
  end)
end

---@param strategy "create"|"picker"
---@param on_resolved fun(note: obsidian.Note?)
function H.resolve_note(strategy, on_resolved)
  if strategy == "create" then
    require("obsidian.actions").new(nil, on_resolved)
  else
    require("obsidian.picker").find_notes({
      callback = function(paths) on_resolved(paths[1] and require("obsidian.note").from_file(paths[1])) end,
    })
  end
end

---@param note obsidian.Note
---@return string
function H.link_item(note) return "- " .. note:format_link() end

return M
