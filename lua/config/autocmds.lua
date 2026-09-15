local config_keys = require("config.keys")

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("MyKeyBindings", { clear = true }),
  pattern = "VeryLazy",
  callback = function()
    config_keys.setup_plugin_keymaps()
    config_keys.setup_toggle_keymaps()
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("MyLspKeyBindings", { clear = true }),
  callback = function(ev) config_keys.on_lsp_attach(ev.data.client_id, ev.buf) end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("MyTreesitterKeyBindings", { clear = true }),
  callback = function(ev) config_keys.on_treesitter_attach(ev.match, ev.buf) end,
})

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("MyObsidianKeyBindings", { clear = true }),
  pattern = "ObsidianNoteEnter",
  callback = function(ev) config_keys.on_obsidian_note_enter(ev.buf) end,
})

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("MyOilDeletedFileBuffers", { clear = true }),
  pattern = "OilActionsPost",
  desc = "Delete buffers whose files were deleted in oil",
  callback = function(args)
    local bufdelete = require("snacks.bufdelete")

    for _, action in ipairs(args.data.actions or {}) do
      if action.type == "delete" and action.entry_type == "file" then
        local bufname = action.url:match("^oil://(.*)$") or action.url
        bufdelete({ file = bufname, force = true, wipe = true })
      end
    end
  end,
})
