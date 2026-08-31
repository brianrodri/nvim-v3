return {
    {
        'christoomey/vim-tmux-navigator',
    },

    {
        'stevearc/oil.nvim',
        opts = { view_options = { show_hidden = true } },
    },

    {
        'folke/snacks.nvim',
        priority = 1000,
        lazy = false,
        opts = {
            picker = {
                enabled = true,
                hidden = true,
                sources = {
                    files = { hidden = true },
                    explorer = { hidden = true },
                },
            },
            notifier = { enabled = true },
            input = { enabled = true },
        },
    },
}
