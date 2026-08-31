return {
    {
        'folke/snacks.nvim',
        opts = {
            lazygit = { enabled = true },
        },
    },

    {
        'lewis6991/gitsigns.nvim',
        event = 'BufWinEnter',
        opts = {
            attach_to_untracked = true,
            on_attach = function(bufnr) require('config.keys').on_gitsigns_attach(bufnr) end,
        },
    },
}
