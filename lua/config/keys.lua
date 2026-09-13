local M = {}
local H = {}

function M.on_lazy_attach()
  local my_icons = require("my.icons")
  local oil = require("oil")
  local snacks_lazygit = require("snacks.lazygit")
  local snacks_picker = require("snacks.picker")
  local which_key = require("which-key")

  which_key.add({
    -- Make visual-mode `p` behave like builtin `P`: put without clobbering the register (:h v_P).
    { "p", "P", mode = "x" },

    { "-", function() oil.open() end, desc = "File Explorer (buffer)" },
    { "<esc>", ":nohlsearch<cr>", hidden = true },

    {
      { "<leader><C-h>", ":leftabove vsplit<CR>", desc = "New Left Split" },
      { "<leader><C-j>", ":rightbelow split<CR>", desc = "New Bottom Split" },
      { "<leader><C-k>", ":leftabove split<CR>", desc = "New Top Split" },
      { "<leader><C-l>", ":rightbelow vsplit<CR>", desc = "New Right Split" },
    },

    { "<leader>b", group = "buffer" },
    { "<leader>bd", ":bd!<cr>", desc = "Delete Buffer" },

    { "<leader>c", group = "code", icon = my_icons.code .. " " },
    { "<leader>cd", vim.diagnostic.open_float, desc = "Line Diagnostics" },
    { "]d", H.diagnostic_jump(true), desc = "Next Diagnostic" },
    { "[d", H.diagnostic_jump(false), desc = "Prev Diagnostic" },
    { "]e", H.diagnostic_jump(true, vim.diagnostic.severity.ERROR), desc = "Next Error" },
    { "[e", H.diagnostic_jump(false, vim.diagnostic.severity.ERROR), desc = "Prev Error" },
    { "]w", H.diagnostic_jump(true, vim.diagnostic.severity.WARN), desc = "Next Warning" },
    { "[w", H.diagnostic_jump(false, vim.diagnostic.severity.WARN), desc = "Prev Warning" },

    { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev Todo Comment" },

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
    { "<leader>df", function() H.dap_centered_widget("frames") end, desc = "Show Frames" },
    { "<leader>ds", function() H.dap_centered_widget("scopes") end, desc = "Show Scopes" },

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

    { "<leader>v", group = "vault", icon = { icon = my_icons.vault .. " ", color = "purple" } },
    { "<leader>vn", function() H.new_obsidian_note() end, desc = "New Note" },
    { "<leader>vs", function() require("obsidian.picker").grep_notes() end, desc = "Grep Notes" },
    { "<leader>vf", function() require("obsidian.picker").find_notes() end, desc = "Find Notes" },
    { "<leader>vt", function() require("obsidian.daily").today():open() end, desc = "Daily Note" },
    { "<leader>vr", function() require("snacks.picker").recent() end, desc = "Recent Notes" },

    { "<leader>x", group = "trouble" },
    { "<leader>xt", ":Trouble todo toggle<cr>", desc = "Todo Comments" },
    { "<leader>xT", ":Trouble todo toggle filter.buf=0<cr>", desc = "Todo Comments" },
    { "<leader>xx", ":Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
    { "<leader>xX", ":Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
    { "<leader>xq", ":Trouble quickfix toggle<cr>", desc = "Quickfix List" },
    { "<leader>xl", ":Trouble loclist toggle<cr>", desc = "Location List" },
  })
end

---@param client_id integer
---@param bufnr integer
function M.on_lsp_attach(client_id, bufnr)
  local which_key = require("which-key")

  local client = vim.lsp.get_client_by_id(client_id)
  vim.lsp.completion.enable(true, client_id, bufnr)

  which_key.add({
    buffer = bufnr,

    { "<leader>cj", vim.lsp.buf.incoming_calls, desc = "Incoming Calls" },
    { "<leader>ck", vim.lsp.buf.outgoing_calls, desc = "Outgoing Calls" },

    {
      cond = client and function() return client:supports_method("textDocument/prepareTypeHierarchy") end,
      { "<leader>ct", function() vim.lsp.buf.typehierarchy("subtypes") end, desc = "Subtypes" },
      { "<leader>cT", function() vim.lsp.buf.typehierarchy("supertypes") end, desc = "Supertypes" },
    },
  })
end

---@param ft_match string
---@param bufnr integer
function M.on_treesitter_attach(ft_match, bufnr)
  local nvim_treesitter = require("nvim-treesitter")
  local which_key = require("which-key")

  local lang = vim.iter(nvim_treesitter.get_installed()):find(vim.treesitter.language.get_lang(ft_match))
  if not lang then return end

  vim.treesitter.start(bufnr, lang)
  vim.bo[bufnr].syntax = "ON"
  vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
  vim.wo[0][0].foldmethod = "expr"

  -- Parsers like `vimdoc` and `gitcommit` highlight and fold but ship no `textobjects` query, so the
  -- motions below stay unbound for them.
  if not vim.treesitter.query.get(lang, "textobjects") then return end

  which_key.add({
    buffer = bufnr,
    mode = { "n", "x", "o" },

    { "]f", function() H.goto_textobject("goto_next_start", "@function.outer") end, desc = "Next Function" },
    { "[f", function() H.goto_textobject("goto_previous_start", "@function.outer") end, desc = "Prev Function" },
    { "]F", function() H.goto_textobject("goto_next_end", "@function.outer") end, desc = "Next Function End" },
    { "[F", function() H.goto_textobject("goto_previous_end", "@function.outer") end, desc = "Prev Function End" },

    {
      cond = function() return not vim.wo.diff end,
      { "]c", function() H.goto_textobject("goto_next_start", "@class.outer") end, desc = "Next Class" },
      { "[c", function() H.goto_textobject("goto_previous_start", "@class.outer") end, desc = "Prev Class" },
      { "]C", function() H.goto_textobject("goto_next_end", "@class.outer") end, desc = "Next Class End" },
      { "[C", function() H.goto_textobject("goto_previous_end", "@class.outer") end, desc = "Prev Class End" },
    },
  })
end

---@param bufnr integer
function M.on_gitsigns_attach(bufnr)
  local gitsigns = require("gitsigns")
  local my_icons = require("my.icons")
  local which_key = require("which-key")

  which_key.add({
    buffer = bufnr,

    { "[h", function() gitsigns.nav_hunk("prev") end, desc = "Previous Hunk" },
    { "[H", function() gitsigns.nav_hunk("first") end, desc = "First Hunk" },
    { "]h", function() gitsigns.nav_hunk("next") end, desc = "Next Hunk" },
    { "]H", function() gitsigns.nav_hunk("last") end, desc = "Final Hunk" },
    { "ih", function() gitsigns.select_hunk() end, desc = "Select Hunk", mode = "no" },

    { "<leader>h", group = "hunk", icon = { icon = my_icons.hunk .. " ", color = "purple" } },
    { "<leader>ha", function() gitsigns.stage_hunk() end, desc = "Stage Hunk" },
    { "<leader>hA", function() gitsigns.stage_buffer() end, desc = "Stage Buffer" },
    { "<leader>hr", function() gitsigns.reset_hunk() end, desc = "Reset Hunk" },
    { "<leader>hR", function() gitsigns.reset_buffer() end, desc = "Reset Buffer" },
    { "<leader>hk", function() gitsigns.preview_hunk_inline() end, desc = "Preview Hunk (Inline)" },
    { "<leader>hK", function() gitsigns.preview_hunk() end, desc = "Preview Hunk" },
    { "<leader>hb", function() H.pick_gitsigns_branch(true) end, desc = "Change Base (Global)" },
    { "<leader>hB", function() H.pick_gitsigns_branch(false) end, desc = "Change Base (Buffer)" },
  })
end

function M.setup_snacks_toggle_keymaps()
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
  snacks_toggle.scroll():map("<leader>uS")
  snacks_toggle
    .new({
      id = "gitsigns",
      name = "Git Signs",
      set = function(state) require("gitsigns").toggle_signs(state) end,
      get = function() return require("gitsigns.config").config.signcolumn end,
    })
    :map("<leader>ug")
end

---@param towards_eof boolean?
---@param severity vim.diagnostic.Severity?
function H.diagnostic_jump(towards_eof, severity)
  return function()
    vim.diagnostic.jump({
      count = (towards_eof and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    })
  end
end

---@param widget "frames"|"scopes"
function H.dap_centered_widget(widget)
  local w = require("dap.ui.widgets")
  w.centered_float(w[widget])
end

function H.new_obsidian_note()
  require("obsidian.actions").new(nil, function(n) n:open() end)
end

---@param method "goto_next_start"|"goto_next_end"|"goto_previous_start"|"goto_previous_end"
---@param query string a capture from `textobjects.scm`, e.g. `"@function.outer"`.
function H.goto_textobject(method, query) require("nvim-treesitter-textobjects.move")[method](query, "textobjects") end

---@param global boolean whether to change the base of all buffers.
function H.pick_gitsigns_branch(global)
  local gitsigns = require("gitsigns")
  local my_icons = require("my.icons")

  require("snacks.picker").pick({
    all = true,
    finder = "git_branches",
    format = "git_branch",
    preview = "git_log",
    title = "Change Base " .. my_icons.change_base .. " ",
    confirm = function(picker, item)
      picker:close()
      if not item then return end
      local ref = item.branch or item.commit
      if ref then gitsigns.change_base(ref, global) end
    end,
  })
end

return M
