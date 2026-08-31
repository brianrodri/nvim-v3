vim.api.nvim_create_autocmd('User', {
    group = vim.api.nvim_create_augroup('my.key-bindings', { clear = true }),
    pattern = 'VeryLazy',
    callback = function() require('config.keys').on_lazy_attach() end,
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp.key-bindings', { clear = true }),
    callback = function(ev)
        vim.lsp.completion.enable(true, ev.data.client_id, ev.buf)
        require('config.keys').on_lsp_attach(ev.data.client_id, ev.buf)
    end,
})
