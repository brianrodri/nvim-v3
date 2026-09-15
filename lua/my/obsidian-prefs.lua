local M = {}
local H = {}

function M.generate_note_id()
  local now = os.date("*t")
  local seconds = now.sec + (H.SEC_PER_MIN * now.min) + (H.SEC_PER_HOUR * now.hour)
  local base36_chars = {}
  while seconds > 0 do
    local lua_index = seconds % #H.BASE36_DIGIT_CHARS + 1
    table.insert(base36_chars, H.BASE36_DIGIT_CHARS:sub(lua_index, lua_index))
    seconds = math.floor(seconds / #H.BASE36_DIGIT_CHARS)
  end
  local suffix = vim.iter(base36_chars):rev():join("")
  return os.date("%y%m%d") .. string.rep("0", H.BASE36_DIGITS_PER_DAY - #suffix) .. suffix
end

--- Names a new note after its title, falling back to `M.generate_note_id` when it has none.
---
--- `obsidian.nvim` calls this for every note it creates, handing it whatever was typed at the creation
--- prompt. `builtin.title_id` slugifies that text and breaks collisions against `dir`.
---
---@param title string|? the text typed at the creation prompt, if any.
---@param dir obsidian.Path|? the directory the note will be written to.
---@return string
function M.resolve_note_id(title, dir)
  if title == nil or title == "" then return M.generate_note_id() end
  return require("obsidian.builtin").title_id(title, dir)
end

---@param note obsidian.Note
function M.sanitize_frontmatter(note)
  local fstat = note.path and vim.uv.fs_stat(tostring(note.path))
  local ctime = fstat and H.parse_time(fstat.ctime) or os.time()
  local mtime = fstat and H.parse_time(fstat.mtime) or ctime

  return vim.tbl_deep_extend(
    "force",
    { id = note.id, title = note.title, dateCreated = H.format_time(ctime), dateModified = H.format_time(mtime) },
    H.default_frontmatter(note.path),
    vim.deepcopy(note.metadata)
  )
end

---@module 'obsidian'
---@param path obsidian.Path
function H.default_frontmatter(path)
  if vim.iter(path and path:parents() or {}):any(function(p) return vim.endswith(tostring(p), "tasks") end) then
    return { kind = "task", status = "open", priority = "normal", scheduled = os.date("%m/%d/%Y") }
  else
    return { kind = "memo" }
  end
end

---@param time_value {sec: number, nsec: number}|?
function H.parse_time(time_value)
  if type(time_value) ~= "table" then return error("unparsable time_value=" .. vim.inspect(time_value)) end
  local sec = vim.tbl_get(time_value, "sec") or 0
  local nsec = vim.tbl_get(time_value, "nsec") or 0
  return sec + nsec / H.NSEC_PER_SEC
end

---@param input number|?
function H.format_time(input) return os.date("%Y-%m-%dT%H:%M:%S.000-04:00", input or os.time()) end

H.BASE36_DIGIT_CHARS = "0123456789abcdefghijklmnopqrstuvwxyz"
H.NSEC_PER_SEC = 1000000000
H.SEC_PER_MIN = 60
H.SEC_PER_HOUR = 60 * H.SEC_PER_MIN
H.BASE36_DIGITS_PER_DAY = math.ceil(math.log(24 * H.SEC_PER_HOUR, #H.BASE36_DIGIT_CHARS))

return M
