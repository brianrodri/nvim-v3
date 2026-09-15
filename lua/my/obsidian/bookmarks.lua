---@module 'obsidian'

local M = {}
local H = {}

--- Opens a bookmark, skipping the picker when the vault holds exactly one.
---
--- This is `:Obsidian bookmarks` plus the single-bookmark shortcut.
function M.open()
  local items = H.read()
  if #items > 1 then
    require("obsidian.bookmarks").pick(items)
  elseif #items == 1 then
    H.open_only(items)
  else
    require("obsidian.log").warn("Nothing is bookmarked")
  end
end

--- Prepends a line of text to a bookmarked note without leaving the current buffer.
function M.append()
  local items = H.collect_files(H.read())
  if #items > 1 then
    require("obsidian.picker").select(items, {
      prompt = "Append to bookmark",
      format_item = function(bookmark) return bookmark.title or bookmark.path end,
    }, function(choices)
      if choices[1] then H.prepend_to(choices[1]) end
    end)
  elseif #items == 1 then
    H.prepend_to(items[1])
  else
    -- Distinct from `M.open`: url, search and folder bookmarks exist but cannot take text.
    require("obsidian.log").warn("Nothing is bookmarked")
  end
end

--- Bookmarks the current note, or drops the bookmark it already has.
function M.toggle() H.note_toggle():toggle() end

--- Describes what `M.toggle` would do next, for `which-key`.
---
---@return string
function M.desc() return H.note_toggle():get() and "Drop Bookmark" or "Pick Bookmark" end

--- Shows whether the current note is bookmarked, for `which-key`.
---
---@return { icon: string, color: string }
function M.icon()
  local my_icons = require("my.icons")
  if H.note_toggle():get() then
    return { icon = my_icons.bookmark_on .. " ", color = "green" }
  else
    return { icon = my_icons.bookmark_off .. " ", color = "yellow" }
  end
end

--- The toggle backing `M.toggle`, built once and reused so `which-key` can read live state.
---
--- It deliberately ignores heading and block bookmarks, so that `get` and `set` stay symmetric and toggling
--- can never silently discard a more specific bookmark. Use the `Bookmark ...` LSP code action for those.
---
---@return snacks.toggle.Class
function H.note_toggle()
  local toggle = require("snacks.toggle")

  return toggle.get(H.TOGGLE_ID)
    or toggle.new({
      id = H.TOGGLE_ID,
      name = "Bookmark",
      -- `Toggle:map` would register a global which-key entry for a buffer-local key, so bind it by hand.
      which_key = false,
      get = function() return H.current_note() ~= nil end,
      set = function(state)
        local bookmarks = require("obsidian.bookmarks")
        local bookmarked = H.current_note()
        if state and not bookmarked then
          local note = assert(require("obsidian.api").current_note(0), "not in a note")
          bookmarks.add({
            ctime = bookmarks.new_ctime(),
            type = "file",
            path = note.path:vault_relative_path({ strict = true }),
            title = note:display_name(),
          })
        elseif not state and bookmarked then
          bookmarks.del(bookmarked)
        end
      end,
    })
end

--- Finds the whole-note bookmark pointing at the current note, if it has one.
---
---@return obsidian.Bookmark?
function H.current_note()
  local note = require("obsidian.api").current_note(0)
  if not note or not note.path then return nil end

  local wanted = note.path:vault_relative_path()
  return vim
    .iter(H.collect_files(H.read()))
    :find(function(bookmark) return bookmark.path == wanted and not bookmark.subpath end)
end

--- Reads the vault's bookmark list, or returns `nil` when the vault has no bookmark file at all.
---
---@return obsidian.Bookmark[]
function H.read()
  local bookmarks = require("obsidian.bookmarks")
  local path = bookmarks.resolve_bookmark_file()
  if not path then return {} end
  local file = assert(io.open(path, "r"), "failed to open bookmarks file")
  local items = bookmarks.parse(file:read("*a"))
  file:close()
  return items
end

--- Opens the only bookmark there is, without putting a one-item picker in the way.
---
--- `obsidian.bookmarks` keeps `open_bookmark` private, and it already handles every bookmark type (note with
--- an anchor, folder, url, saved search, group). Rather than duplicate that, auto-confirm its own picker.
---
---@param items obsidian.Bookmark[] exactly one bookmark.
function H.open_only(items)
  local picker = require("obsidian.picker")
  local select = picker.select
  picker.select = function(_, _, on_choice) on_choice({ items[1] }) end
  local ok, err = pcall(require("obsidian.bookmarks").pick, items)
  picker.select = select
  if not ok then error(err) end
end

---@param bookmark obsidian.Bookmark
function H.prepend_to(bookmark)
  local api = require("obsidian.api")
  local text = api.input("Append")
  if not text or text == "" then return end
  local note = require("obsidian.note").from_file(api.resolve_workspace_dir() / bookmark.path)
  -- `placement` has no default, so "top" must be explicit for the newest capture to land first.
  note:insert_text(text, { placement = "top" })
end

--- Flattens the bookmark tree down to the `file` bookmarks, which are the only ones text can be appended to.
---
---@param bookmarks obsidian.Bookmark[]
---@param acc obsidian.Bookmark[]|?
---@return obsidian.Bookmark[]
function H.collect_files(bookmarks, acc)
  acc = acc or {}
  for _, bookmark in ipairs(bookmarks) do
    if bookmark.type == "file" and bookmark.path then
      acc[#acc + 1] = bookmark
    elseif bookmark.type == "group" then
      H.collect_files(bookmark.items or {}, acc)
    end
  end
  return acc
end

H.TOGGLE_ID = "obsidian_bookmark"

return M
