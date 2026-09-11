-- Make visual-mode `p` behave like builtin `P`: put without clobbering the register (:h v_P).
vim.keymap.set("x", "p", "P")

---@param towards_eof boolean?
---@param severity vim.diagnostic.Severity?
local function diagnostic_jump(towards_eof, severity)
  return function()
    vim.diagnostic.jump({
      count = (towards_eof and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    })
  end
end

-- The `]`/`[` families below are the only parts of `vim-unimpaired` that Neovim does not already
-- ship, which is what let the plugin go. `:h default-mappings` covers `]q`/`]l`/`]b`/`]a`/`]t` and
-- `]<Space>` natively, so they are deliberately absent here. Also not carried over: `[e`/`]e` (move
-- line, lost to Next/Prev Error above), `[f`/`]f` (directory, now treesitter function motions), and
-- the `[x`/`[u`/`[y`/`[C` encode operators.

-- A diff hunk header or a merge conflict marker: what unimpaired's `]n`/`[n` searched for.
local conflict_pattern = [[^\(@@ .* @@\|[<=>|]\{7}[<=>|]\@!\)]]

---@param reverse boolean?
local function conflict_jump(reverse)
  return function() vim.fn.search(conflict_pattern, reverse and "bW" or "W") end
end

--- Selects the enclosing diff hunk or conflict block, so `]n`/`[n` stay usable as operator-pending
--- motions (`d]n`, `y[n`) and not just cursor jumps.
---@param reverse boolean?
local function conflict_motion(reverse)
  return function()
    if reverse then vim.cmd("normal! -") end
    vim.fn.search([[^@@ .* @@\|^diff \|^[<=>|]\{7}[<=>|]\@!]], "bWc")

    local line, last = vim.fn.getline("."), vim.fn.line("$")
    local stop ---@type integer?
    if line:match("^diff ") then
      stop = vim.fn.search([[^diff ]], "Wn") - 1
    elseif line:match("^@@ ") then
      stop = vim.fn.search([[^@@ .* @@\|^diff ]], "Wn") - 1
    elseif vim.fn.match(line, [[^=\{7}]]) >= 0 then
      vim.cmd("normal! +")
      stop = vim.fn.search([[^>\{7}>\@!]], "Wnc")
    elseif vim.fn.match(line, [[^[<=>|]\{7}[<=>|]\@!]]) >= 0 then
      stop = vim.fn.search([[^[<=>|]\{7}[<=>|]\@!]], "Wn") - 1
    else
      return
    end
    if stop < 0 then stop = last end

    local from = vim.fn.line(".")
    if stop > from then
      vim.cmd("normal! V" .. (stop - from) .. "j")
    elseif stop == from then
      vim.cmd("normal! V")
    end
  end
end

-- `:h 'hlsearch'` and `:h 'ignorecase'` are global; unimpaired set those with `:set` and the rest
-- with `:setlocal`, which is what keeps a toggle from leaking into every other window.
local global_options = { hlsearch = true, ignorecase = true }

---@param names string[] set together, so `yox` can drive cursorline and cursorcolumn as a pair.
---@param value boolean? omitted to flip the current value.
local function set_options(names, value)
  return function()
    for _, name in ipairs(names) do
      local scope = global_options[name] and vim.opt or vim.opt_local
      -- Not a `and`/`or` ternary: flipping a currently-enabled option yields `false`, which would
      -- fall through to `value` and set `nil`.
      if value == nil then
        scope[name] = not vim.o[name]
      else
        scope[name] = value
      end
    end
  end
end

---@param names string[]
---@return { on: fun(), off: fun(), toggle: fun(), desc: string }
local function option_toggle(names)
  return {
    on = set_options(names, true),
    off = set_options(names, false),
    toggle = set_options(names),
    desc = table.concat(names, " + "),
  }
end

---@param on string ex command enabling the option.
---@param off string ex command disabling it.
---@param enabled fun(): boolean
---@param desc string
---@return { on: fun(), off: fun(), toggle: fun(), desc: string }
local function command_toggle(on, off, enabled, desc)
  return {
    on = function() vim.cmd(on) end,
    off = function() vim.cmd(off) end,
    toggle = function() vim.cmd(enabled() and off or on) end,
    desc = desc,
  }
end

-- Restores whatever `:h 'colorcolumn'` was set to before `]ot` cleared it.
local saved_colorcolumn = vim.o.colorcolumn

---@type table<string, { on: fun(), off: fun(), toggle: fun(), desc: string }>
local option_toggles = {
  b = command_toggle(
    "set background=light",
    "set background=dark",
    function() return vim.o.background == "light" end,
    "light background"
  ),
  c = option_toggle({ "cursorline" }),
  ["-"] = option_toggle({ "cursorline" }),
  ["_"] = option_toggle({ "cursorline" }),
  d = command_toggle("diffthis", "diffoff", function() return vim.wo.diff end, "diff"),
  h = option_toggle({ "hlsearch" }),
  i = option_toggle({ "ignorecase" }),
  l = option_toggle({ "list" }),
  n = option_toggle({ "number" }),
  r = option_toggle({ "relativenumber" }),
  s = option_toggle({ "spell" }),
  u = option_toggle({ "cursorcolumn" }),
  ["|"] = option_toggle({ "cursorcolumn" }),
  v = command_toggle(
    "set virtualedit+=all",
    "set virtualedit-=all",
    function() return vim.o.virtualedit:find("all") ~= nil end,
    "virtualedit"
  ),
  w = option_toggle({ "wrap" }),
  x = option_toggle({ "cursorline", "cursorcolumn" }),
  ["+"] = option_toggle({ "cursorline", "cursorcolumn" }),
  t = {
    on = function() vim.opt_local.colorcolumn = saved_colorcolumn ~= "" and saved_colorcolumn or "+1" end,
    off = function()
      if vim.o.colorcolumn ~= "" then saved_colorcolumn = vim.o.colorcolumn end
      vim.opt_local.colorcolumn = ""
    end,
    toggle = function() end, -- replaced below, once `on`/`off` exist to call.
    desc = "colorcolumn",
  },
}
option_toggles.t.toggle = function()
  if vim.o.colorcolumn == "" then
    option_toggles.t.on()
  else
    option_toggles.t.off()
  end
end

--- Expands `option_toggles` into unimpaired's three prefixes: `[o` enables, `]o` disables, `yo`
--- flips.
local function option_toggle_keys()
  local keys = {
    { "[o", group = "enable option" },
    { "]o", group = "disable option" },
    { "yo", group = "toggle option" },
    { "yo<Esc>", "<Nop>", hidden = true },
  }
  for letter, spec in pairs(option_toggles) do
    vim.list_extend(keys, {
      { "[o" .. letter, spec.on, desc = "Enable " .. spec.desc },
      { "]o" .. letter, spec.off, desc = "Disable " .. spec.desc },
      { "yo" .. letter, spec.toggle, desc = "Toggle " .. spec.desc },
    })
  end
  return keys
end

--- Coerces the register to linewise before the builtin indent-adjusting put, which is the whole of
--- what unimpaired's `[p`/`]p` added on top of `:h ]p`.
---@param keys "[p"|"]p"
local function put_linewise(keys)
  return function()
    local register = vim.v.register
    local body, kind = vim.fn.getreg(register), vim.fn.getregtype(register)

    -- `:`, `%` and `.` are read-only, so stage their contents in the unnamed register instead.
    local restore ---@type [string, string]?
    if register:match("[:%%.]") then
      restore = { vim.fn.getreg('"'), vim.fn.getregtype('"') }
      register = '"'
      vim.fn.setreg(register, body, kind)
    end

    local put = ('normal! "%s%d%s'):format(register, vim.v.count1, keys)
    if kind == "V" then
      vim.cmd(put)
    else
      vim.fn.setreg(register, body, "l")
      vim.cmd(put)
      vim.fn.setreg(register, body, kind)
    end

    if restore then vim.fn.setreg('"', restore[1], restore[2]) end
  end
end

--- Gives a Trouble mode a mapping in both groups it belongs to, so it reads the same from either
--- prefix: `<leader>xc` is mirrored as `<leader>cx`, and `<leader>xC` as `<leader>cX`. The suffix
--- letter names the sibling group; its case selects the variant and stays on the final character.
---@param key string the suffix under `<leader>x`, e.g. `"c"` or `"F"`.
---@param cmd string
---@param desc string
local function trouble_mirror(key, cmd, desc)
  local group = key:lower()
  return {
    { "<leader>x" .. key, cmd, desc = desc },
    { "<leader>" .. group .. (key == group and "x" or "X"), cmd, desc = desc },
  }
end

local icons = require("my.icons")

return {
  on_lazy_attach = function()
    local oil = require("oil")
    local snacks_lazygit = require("snacks.lazygit")
    local snacks_picker = require("snacks.picker")
    local which_key = require("which-key")
    local snacks_toggle = require("snacks.toggle")

    snacks_toggle.option("spell", { name = "Spelling" }):map("<leader>us")
    snacks_toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
    snacks_toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
    snacks_toggle.diagnostics():map("<leader>ud")
    snacks_toggle.line_number():map("<leader>ul")
    snacks_toggle.option("conceallevel", { off = 0, on = 2, name = "Conceal Level" }):map("<leader>uc")
    snacks_toggle.option("showtabline", { off = 0, on = 2, name = "Tabline" }):map("<leader>uA")
    snacks_toggle.treesitter():map("<leader>uT")
    snacks_toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
    snacks_toggle.dim():map("<leader>uD")
    snacks_toggle.animate():map("<leader>ua")
    snacks_toggle.indent():map("<leader>ug")
    snacks_toggle.scroll():map("<leader>uS")
    snacks_toggle.profiler():map("<leader>dpp")
    snacks_toggle.profiler_highlights():map("<leader>dph")

    which_key.add({
      { "-", function() oil.open() end, desc = "File Explorer (buffer)" },
      { "<esc>", ":nohlsearch<cr>", hidden = true },

      {
        { "<leader><C-h>", ":leftabove vsplit<CR>", desc = "New Left Split" },
        { "<leader><C-j>", ":rightbelow split<CR>", desc = "New Bottom Split" },
        { "<leader><C-k>", ":leftabove split<CR>", desc = "New Top Split" },
        { "<leader><C-l>", ":rightbelow vsplit<CR>", desc = "New Right Split" },
        hidden = true,
      },

      { "<leader>b", group = "buffer" },
      { "<leader>bd", ":bd!<cr>", desc = "Delete Buffer" },

      { "<leader>c", group = "code", icon = icons.code .. " " },
      { "<leader>cd", vim.diagnostic.open_float, desc = "Line Diagnostics" },
      { "]d", diagnostic_jump(true), desc = "Next Diagnostic" },
      { "[d", diagnostic_jump(false), desc = "Prev Diagnostic" },
      { "]e", diagnostic_jump(true, vim.diagnostic.severity.ERROR), desc = "Next Error" },
      { "[e", diagnostic_jump(false, vim.diagnostic.severity.ERROR), desc = "Prev Error" },
      { "]w", diagnostic_jump(true, vim.diagnostic.severity.WARN), desc = "Next Warning" },
      { "[w", diagnostic_jump(false, vim.diagnostic.severity.WARN), desc = "Prev Warning" },

      -- nvim-treesitter owns `[n`/`]n` in visual mode, so these claim normal and operator-pending.
      { "]n", conflict_jump(), desc = "Next Conflict", mode = "n" },
      { "[n", conflict_jump(true), desc = "Prev Conflict", mode = "n" },
      { "]n", conflict_motion(), desc = "Next Conflict", mode = "o" },
      { "[n", conflict_motion(true), desc = "Prev Conflict", mode = "o" },

      { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev Todo Comment" },

      { "]p", put_linewise("]p"), desc = "Put Below (linewise)" },
      { "[p", put_linewise("[p"), desc = "Put Above (linewise)" },
      { "]P", put_linewise("]p"), desc = "Put Below (linewise)" },
      { "[P", put_linewise("[p"), desc = "Put Above (linewise)" },

      option_toggle_keys(),

      { "<leader>d", group = "debug" },
      { "<leader>dg", function() require("dap").continue() end, desc = "Start/Resume" },
      { "<leader>d.", function() require("dap").run_last() end, desc = "Restart" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle UI" },
      { "<leader>dl", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dj", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>dk", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>dK", function() require("dap.ui.widgets").hover() end, desc = "Show Hover", mode = { "n", "v" } },
      { "<leader>dp", function() require("dap.ui.widgets").preview() end, desc = "Show Preview", mode = { "n", "v" } },
      {
        "<leader>df",
        function()
          local w = require("dap.ui.widgets")
          w.centered_float(w.frames)
        end,
        desc = "Show Frames",
      },
      {
        "<leader>ds",
        function()
          local w = require("dap.ui.widgets")
          w.centered_float(w.scopes)
        end,
        desc = "Show Scopes",
      },

      { "<leader>f", group = "find" },
      { "<leader>f:", function() snacks_picker.commands() end, desc = "Find Command" },
      { "<leader>f.", function() snacks_picker.resume() end, desc = "Resume Finding" },
      { "<leader>f/", function() snacks_picker.grep() end, desc = "Find Pattern" },
      { "<leader>f*", function() snacks_picker.grep_word() end, desc = "Find Word Under Cursor" },
      { "<leader>fb", function() snacks_picker.buffers() end, desc = "Find Buffers" },
      { "<leader>fc", function() snacks_picker.lazy() end, desc = "Find Lazy Config" },
      { "<leader>fd", function() snacks_picker.diagnostics() end, desc = "Find Diagnostic" },
      { "<leader>ff", function() snacks_picker.files() end, desc = "Find Files" },
      { "<leader>fg", function() snacks_picker.git_status() end, desc = "Find Diff" },
      { "<leader>fh", function() snacks_picker.help() end, desc = "Find Help" },
      { "<leader>fi", function() snacks_picker.icons() end, desc = "Find Icon" },
      {
        "<leader>fl",
        function() snacks_picker.files({ dirs = { vim.fn.stdpath("data") } }) end,
        desc = "Find Plugin Spec",
      },
      { "<leader>fn", function() snacks_picker.notifications() end, desc = "Find Notification" },
      { "<leader>fp", function() snacks_picker.pickers() end, desc = "Find Picker" },
      { "<leader>fr", function() snacks_picker.recent() end, desc = "Find Recent" },
      { "<leader>fv", function() require("obsidian.picker").find_notes() end, desc = "Find Notes" },

      { "<leader>g", group = "git" },
      { "<leader>gg", function() snacks_lazygit() end, desc = "Lazygit" },

      { "<leader>l", group = "lazy" },
      { "<leader>ll", ":Lazy<CR>", desc = "Lazy" },

      { "<leader>q", ":qa!<cr>", desc = "Quit" },

      { "<leader>w", ":w!<cr>", desc = "Write Buffer" },

      { "<leader>v", group = "vault", icon = { icon = icons.vault .. " ", color = "purple" } },
      {
        "<leader>vn",
        function()
          require("obsidian.actions").new(nil, function(n) n:open() end)
        end,
        desc = "New Note",
      },
      { "<leader>vs", function() require("obsidian.picker").grep_notes() end, desc = "Grep Notes" },
      { "<leader>vf", function() require("obsidian.picker").find_notes() end, desc = "Find Notes" },
      { "<leader>vt", function() require("obsidian.daily").today():open() end, desc = "Daily Note" },
      { "<leader>vr", function() require("snacks.picker").recent() end, desc = "Recent Notes" },

      { "<leader>x", group = "trouble" },
      { "<leader>xx", ":Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
      { "<leader>xX", ":Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
      -- No quickfix entry: `qflist` opens itself, and `]q`/`[q` already step it.
      { "<leader>xl", ":Trouble loclist toggle<cr>", desc = "Location List" },
      trouble_mirror("c", ":Trouble symbols toggle<cr>", "Symbols"),
      trouble_mirror("C", ":Trouble lsp toggle<cr>", "LSP References"),
      trouble_mirror("f", ":Trouble todo toggle<cr>", "Todo Comments"),
      trouble_mirror("F", ":Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", "Todo/Fix/Fixme"),
    })
  end,

  on_lsp_attach = function(client_id, bufnr)
    local which_key = require("which-key")
    local client = vim.lsp.get_client_by_id(client_id)

    which_key.add({
      buffer = bufnr,

      { "<leader>cj", vim.lsp.buf.incoming_calls, desc = "Incoming Calls" },
      { "<leader>ck", vim.lsp.buf.outgoing_calls, desc = "Outgoing Calls" },

      {
        cond = client and client:supports_method("textDocument/prepareTypeHierarchy"),
        { "<leader>ct", function() vim.lsp.buf.typehierarchy("subtypes") end, desc = "Subtypes" },
        { "<leader>cT", function() vim.lsp.buf.typehierarchy("supertypes") end, desc = "Supertypes" },
      },
    })
  end,

  on_treesitter_attach = function(bufnr)
    local move = require("nvim-treesitter-textobjects.move")
    local which_key = require("which-key")

    ---@param method "goto_next_start"|"goto_next_end"|"goto_previous_start"|"goto_previous_end"
    ---@param query string a capture from `textobjects.scm`, e.g. `"@function.outer"`.
    ---@param lhs string
    local function goto_textobject(method, query, lhs)
      return function()
        -- `[c`/`]c` are `:h :diffthis` navigation first; only steal them outside a diff window.
        if vim.wo.diff and lhs:find("[cC]") then return vim.cmd("normal! " .. lhs) end
        move[method](query, "textobjects")
      end
    end

    which_key.add({
      buffer = bufnr,
      mode = { "n", "x", "o" },

      { "]f", goto_textobject("goto_next_start", "@function.outer", "]f"), desc = "Next Function" },
      { "[f", goto_textobject("goto_previous_start", "@function.outer", "[f"), desc = "Prev Function" },
      { "]F", goto_textobject("goto_next_end", "@function.outer", "]F"), desc = "Next Function End" },
      { "[F", goto_textobject("goto_previous_end", "@function.outer", "[F"), desc = "Prev Function End" },

      { "]c", goto_textobject("goto_next_start", "@class.outer", "]c"), desc = "Next Class" },
      { "[c", goto_textobject("goto_previous_start", "@class.outer", "[c"), desc = "Prev Class" },
      { "]C", goto_textobject("goto_next_end", "@class.outer", "]C"), desc = "Next Class End" },
      { "[C", goto_textobject("goto_previous_end", "@class.outer", "[C"), desc = "Prev Class End" },
    })
  end,

  on_gitsigns_attach = function(bufnr)
    local gitsigns = require("gitsigns")
    local snacks_picker = require("snacks.picker")
    local which_key = require("which-key")

    -- @param global whether to change the base of all buffers.
    local function pick_gitsigns_branch(global)
      snacks_picker.pick({
        all = true,
        finder = "git_branches",
        format = "git_branch",
        preview = "git_log",
        title = "Change Base " .. icons.change_base .. " ",
        confirm = function(picker, item)
          picker:close()
          if not item then return end
          local ref = item.branch or item.commit
          if ref then gitsigns.change_base(ref, global) end
        end,
      })
    end

    which_key.add({
      buffer = bufnr,

      { "[h", function() gitsigns.nav_hunk("prev") end, desc = "Previous Hunk" },
      { "[H", function() gitsigns.nav_hunk("first") end, desc = "First Hunk" },
      { "]h", function() gitsigns.nav_hunk("next") end, desc = "Next Hunk" },
      { "]H", function() gitsigns.nav_hunk("last") end, desc = "Final Hunk" },
      { "ih", function() gitsigns.select_hunk() end, desc = "Select Hunk", mode = "no" },

      { "<leader>h", group = "hunk", icon = { icon = icons.hunk .. " ", color = "purple" } },
      { "<leader>ha", function() gitsigns.stage_hunk() end, desc = "Stage Hunk" },
      { "<leader>hA", function() gitsigns.stage_buffer() end, desc = "Stage Buffer" },
      { "<leader>hr", function() gitsigns.reset_hunk() end, desc = "Reset Hunk" },
      { "<leader>hR", function() gitsigns.reset_buffer() end, desc = "Reset Buffer" },
      { "<leader>hk", function() gitsigns.preview_hunk_inline() end, desc = "Preview Hunk (Inline)" },
      { "<leader>hK", function() gitsigns.preview_hunk() end, desc = "Preview Hunk" },
      { "<leader>hb", function() pick_gitsigns_branch(true) end, desc = "Change Base (Global)" },
      { "<leader>hB", function() pick_gitsigns_branch(false) end, desc = "Change Base (Buffer)" },
    })
  end,
}
