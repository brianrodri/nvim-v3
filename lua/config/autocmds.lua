vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("my.key-bindings", { clear = true }),
  pattern = "VeryLazy",
  callback = function() require("config.keys").on_lazy_attach() end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("my.lsp.key-bindings", { clear = true }),
  callback = function(ev)
    vim.lsp.completion.enable(true, ev.data.client_id, ev.buf)
    require("config.keys").on_lsp_attach(ev.data.client_id, ev.buf)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("my.treesitter.key-bindings", { clear = true }),
  callback = function(ev)
    -- The `]f`/`]c` motions need both a parser and this language's `textobjects.scm`; coverage is
    -- per-language, so bind them only where they can actually resolve a capture.
    local lang = vim.treesitter.language.get_lang(ev.match)
    if not lang or not vim.iter(require("nvim-treesitter").get_installed()):find(lang) then return end
    if not vim.treesitter.query.get(lang, "textobjects") then return end
    require("config.keys").on_treesitter_attach(ev.buf)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("MyTreesitterHighlight", { clear = true }),
  callback = function(ev)
    local nvim_treesitter = require("nvim-treesitter")
    if not vim.iter(nvim_treesitter.get_installed()):find(ev.match) then return end
    vim.treesitter.start(ev.buf, ev.match)
    vim.bo[ev.buf].syntax = "ON"
    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo[0][0].foldmethod = "expr"
  end,
})
