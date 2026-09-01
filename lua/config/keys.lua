vim.cmd([[ xnoremap <expr> p 'pgv''.v:register.'y' ]])

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

return {
    on_lazy_attach = function()
        local oil = require('oil')
        local snacks_lazygit = require('snacks.lazygit')
        local snacks_picker = require('snacks.picker')
        local which_key = require('which-key')
        local snacks_toggle = require('snacks.toggle')

        snacks_toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        snacks_toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        snacks_toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        snacks_toggle.diagnostics():map("<leader>ud")
        snacks_toggle.line_number():map("<leader>ul")
        snacks_toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }):map("<leader>uc")
        snacks_toggle.option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" }):map("<leader>uA")
        snacks_toggle.treesitter():map("<leader>uT")
        snacks_toggle.option("background", { off = "light", on = "dark" , name = "Dark Background" }):map("<leader>ub")
        snacks_toggle.dim():map("<leader>uD")
        snacks_toggle.animate():map("<leader>ua")
        snacks_toggle.indent():map("<leader>ug")
        snacks_toggle.scroll():map("<leader>uS")
        snacks_toggle.profiler():map("<leader>dpp")
        snacks_toggle.profiler_highlights():map("<leader>dph")

        which_key.add({
            { '-', function() oil.open() end, desc = 'File Explorer (buffer)' },
            { '<esc>', ':nohlsearch<cr>', hidden = true },

            {
                { '<leader><C-h>', ':leftabove vsplit<CR>', desc = 'New Left Split' },
                { '<leader><C-j>', ':rightbelow split<CR>', desc = 'New Bottom Split' },
                { '<leader><C-k>', ':leftabove split<CR>', desc = 'New Top Split' },
                { '<leader><C-l>', ':rightbelow vsplit<CR>', desc = 'New Right Split' },
                hidden = true,
            },

            { '<leader>b', group = 'buffer' },
            { '<leader>bd', ':bd!<cr>', desc = 'Delete Buffer' },

            { '<leader>c', group = 'code', icon = ' ' },
            { '<leader>cd', vim.diagnostic.open_float, desc = 'Line Diagnostics' },
            { ']d', diagnostic_jump(true), desc = 'Next Diagnostic' },
            { '[d', diagnostic_jump(false), desc = 'Prev Diagnostic' },
            { ']e', diagnostic_jump(true, vim.diagnostic.severity.ERROR), desc = 'Next Error' },
            { '[e', diagnostic_jump(false, vim.diagnostic.severity.ERROR), desc = 'Prev Error' },
            { ']w', diagnostic_jump(true, vim.diagnostic.severity.WARN), desc = 'Next Warning' },
            { '[w', diagnostic_jump(false, vim.diagnostic.severity.WARN), desc = 'Prev Warning' },


            { "<leader>d", group = 'debug', icon = { icon = ' ', color = 'red' } },
            { "<leader>dg", function() require("dap").continue() end,                                      desc = "Start/Resume" },
            { "<leader>d.", function() require("dap").run_last() end,                                      desc = "Restart" },
            { "<leader>db", function() require("dap").toggle_breakpoint() end,                             desc = "Toggle Breakpoint" },
            { "<leader>du", function() require("dapui").toggle() end,                                      desc = "Toggle UI" },
            { '<leader>dl', function() require('dap').step_over() end,                                     desc = 'Step Over' },
            { '<leader>dj', function() require('dap').step_into() end,                                     desc = 'Step Into' },
            { '<leader>dk', function() require('dap').step_out() end,                                      desc = 'Step Out' },
            { '<leader>dr', function() require('dap').repl.toggle() end,                                   desc = 'Toggle REPL' },
            { '<leader>dK', function() require('dap.ui.widgets').hover() end,                              desc = 'Show Hover',   mode = { 'n', 'v' } },
            { '<leader>dp', function() require('dap.ui.widgets').preview() end,                            desc = 'Show Preview', mode = { 'n', 'v' } },
            { '<leader>df', function() local w = require('dap.ui.widgets') w.centered_float(w.frames) end, desc = 'Show Frames' },
            { '<leader>ds', function() local w = require('dap.ui.widgets') w.centered_float(w.scopes) end, desc = 'Show Scopes' },

            { '<leader>f', group = 'find' },
            { '<leader>f:', function() snacks_picker.commands() end, desc = 'Find Command' },
            { '<leader>f.', function() snacks_picker.resume() end, desc = 'Resume Finding' },
            { '<leader>f/', function() snacks_picker.grep() end, desc = 'Find Pattern' },
            { '<leader>f*', function() snacks_picker.grep_word() end, desc = 'Find Word Under Cursor' },
            { '<leader>fb', function() snacks_picker.buffers() end, desc = 'Find Buffers' },
            { '<leader>fc', function() snacks_picker.lazy() end, desc = 'Find Lazy Config' },
            { '<leader>fd', function() snacks_picker.diagnostics() end, desc = 'Find Diagnostic' },
            { '<leader>ff', function() snacks_picker.files() end, desc = 'Find Files' },
            { '<leader>fg', function() snacks_picker.git_status() end, desc = 'Find Diff' },
            { '<leader>fh', function() snacks_picker.help() end, desc = 'Find Help' },
            { '<leader>fi', function() snacks_picker.icons() end, desc = 'Find Icon' },
            { '<leader>fl', function() snacks_picker.files({ dirs = { vim.fn.stdpath('data') } }) end, desc = 'Find Plugin Spec' },
            { '<leader>fn', function() snacks_picker.notifications() end, desc = 'Find Notification' },
            { '<leader>fp', function() snacks_picker.pickers() end, desc = 'Find Picker' },
            { '<leader>fr', function() snacks_picker.recent() end, desc = 'Find Recent' },

            { '<leader>g', group = 'git', icon = { icon = '󰊤 ', color = 'grey' } },
            { '<leader>gg', function() snacks_lazygit() end, desc = 'Lazygit' },

            { '<leader>l', group = 'lazy', icon = { icon = '󰒲 ', color = 'azure' } },
            { '<leader>ll', ':Lazy<CR>', desc = 'Lazy' },

            { '<leader>q', group = 'quit' },
            { '<leader>qq', ':qa!<cr>', desc = 'Quit' },

            { '<leader>w', group = 'write', icon = { icon = ' ', color = 'green' } },
            { '<leader>ww', ':w!<cr>', desc = 'Write Buffer' },
            { '<leader>wW', ':wa!<cr>', desc = 'Write All' },
            { '<leader>wq', ':wqa!<cr>', desc = 'Write & Quit' },

            { '<leader>v', group = 'vault', icon = { icon = '󰇈 ', color = 'purple' } },
            { '<leader>vn', function() require('obsidian.actions').new() end, desc = 'New Note' },
            { '<leader>vs', function() require('obsidian.picker').grep_notes() end, desc = 'Grep Notes' },
            { '<leader>vf', function() require('obsidian.picker').find_notes() end, desc = 'Find Notes' },
            { '<leader>vt', function() require('obsidian.daily').today():open() end, desc = 'Daily Note' },
            { '<leader>vr', function() require('snacks.picker').recent() end, desc = 'Recent Notes' },
        })
    end,

    on_lsp_attach = function(client_id, bufnr)
        local which_key = require('which-key')
        local client = vim.lsp.get_client_by_id(client_id)

        which_key.add({
            buffer = bufnr,

            { '<leader>cj', vim.lsp.buf.incoming_calls, desc = 'Incoming Calls' },
            { '<leader>ck', vim.lsp.buf.outgoing_calls, desc = 'Outgoing Calls' },

            {
                cond = client:supports_method('textDocument/prepareTypeHierarchy'),
                { '<leader>ct', function() vim.lsp.buf.typehierarchy('subtypes') end, desc = 'Subtypes' },
                { '<leader>cT', function() vim.lsp.buf.typehierarchy('supertypes') end, desc = 'Supertypes'  },
            }
        })
    end,

    on_gitsigns_attach = function(bufnr)
        local gitsigns = require('gitsigns')
        local snacks_picker = require('snacks.picker')
        local which_key = require('which-key')

        -- @param global whether to change the base of all buffers.
        local function pick_gitsigns_branch(global)
            snacks_picker.pick({
                all = true,
                multi = false,
                finder = 'git_branches',
                format = 'git_branch',
                preview = 'git_log',
                title = 'Change Base  ',
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

            { '[h', function() gitsigns.nav_hunk('prev') end, desc = 'Previous Hunk' },
            { '[H', function() gitsigns.nav_hunk('first') end, desc = 'First Hunk' },
            { ']h', function() gitsigns.nav_hunk('next') end, desc = 'Next Hunk' },
            { ']H', function() gitsigns.nav_hunk('last') end, desc = 'Final Hunk' },
            { 'vih', function() gitsigns.select_hunk() end, desc = 'Select Hunk' },

            { '<leader>h', group = 'hunk', icon = { icon = ' ', color = 'purple' } },
            { '<leader>ha', function() gitsigns.stage_hunk() end, desc = 'Stage Hunk' },
            { '<leader>hA', function() gitsigns.stage_buffer() end, desc = 'Stage Buffer' },
            { '<leader>hr', function() gitsigns.reset_hunk() end, desc = 'Reset Hunk' },
            { '<leader>hR', function() gitsigns.reset_buffer() end, desc = 'Reset Buffer' },
            { '<leader>hk', function() gitsigns.preview_hunk() end, desc = 'Preview Hunk' },
            { '<leader>hK', function() gitsigns.preview_hunk_inline() end, desc = 'Preview Hunk (Inline)' },
            { '<leader>hb', function() pick_gitsigns_branch(false) end, desc = 'Change Base (Buffer)' },
            { '<leader>hB', function() pick_gitsigns_branch(true) end, desc = 'Change Base (Global)' },
        })
    end,
}
