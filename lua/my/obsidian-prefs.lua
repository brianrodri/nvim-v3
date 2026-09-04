local BASE36_DIGIT_CHARS = "0123456789abcdefghijklmnopqrstuvwxyz"
local NSEC_PER_SEC = 1000000000
local SEC_PER_MIN = 60
local SEC_PER_HOUR = 60 * SEC_PER_MIN
local SECONDS_PER_DAY = 24 * SEC_PER_HOUR
local BASE36_DIGITS_PER_DAY = math.ceil(math.log(SECONDS_PER_DAY, #BASE36_DIGIT_CHARS))

---@param path obsidian.Path
local function default_frontmatter(path)
    if vim.iter(path and path:parents() or {}):any(function(p) return vim.endswith(tostring(p), "tasks") end) then
        return { kind = "task", status = "open", priority = "normal", scheduled = os.date("%m/%d/%Y") }
    else
        return { kind = "memo" }
    end
end

---@param time_value {sec: number, nsec: number}|?
local function parse_time(time_value)
    if type(time_value) ~= "table" then return error("unparsable time_value=" .. vim.inspect(time_value)) end
    local sec = vim.tbl_get(time_value, "sec") or 0
    local nsec = vim.tbl_get(time_value, "nsec") or 0
    return sec + nsec / NSEC_PER_SEC
end

---@param input number|?
local function format_time(input)
    return os.date("%Y-%m-%dT%H:%M:%S.000-04:00", input or os.time())
end

local M = {}

--- IDs based on time-of-call that look like "2609041unz": YYMMDD followed by base36 seconds since midnight.
---@type fun(title: string?, path: obsidian.Path?): string
function M.task_notes_adapter()
    local now = os.date("*t")
    local seconds = now.sec + (SEC_PER_MIN * now.min) + (SEC_PER_HOUR * now.hour)
    local base36_chars = {}
    while seconds > 0 do
        local lua_index = seconds % #BASE36_DIGIT_CHARS + 1
        table.insert(base36_chars, BASE36_DIGIT_CHARS:sub(lua_index, lua_index))
        seconds = math.floor(seconds / #BASE36_DIGIT_CHARS)
    end
    local suffix = vim.iter(base36_chars):rev():join('')
    return os.date("%y%m%d") .. string.rep("0", BASE36_DIGITS_PER_DAY - #suffix) .. suffix
end

---@param note obsidian.Note
function M.task_notes_frontmatter_adapter(note)
    local fstat = note.path and vim.uv.fs_stat(tostring(note.path))
    local ctime = fstat and parse_time(fstat.ctime) or os.time()
    local mtime = fstat and parse_time(fstat.mtime) or ctime

    return vim.tbl_deep_extend(
        "force",
        { id = note.id, title = note.title, dateCreated = format_time(ctime), dateModified = format_time(mtime) },
        default_frontmatter(note.path),
        vim.deepcopy(note.metadata)
    )
end

return M
