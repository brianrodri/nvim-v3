local config_keys = require("config.keys")

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("my.key-bindings", { clear = true }),
  pattern = "VeryLazy",
  callback = function()
    config_keys.on_lazy_attach()
    config_keys.setup_snacks_toggle_keymaps()
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("my.lsp.key-bindings", { clear = true }),
  callback = function(ev) config_keys.on_lsp_attach(ev.data.client_id, ev.buf) end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("my.treesitter.key-bindings", { clear = true }),
  callback = function(ev) config_keys.on_treesitter_attach(ev.match, ev.buf) end,
})
