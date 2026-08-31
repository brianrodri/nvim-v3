return {
    {
        'neovim/nvim-lspconfig',
        opts = { ['basedpyright'] = true },
    },

    {
        'mfussenegger/nvim-lint',
        opts = { python = { 'mypy', 'pylint' } },
    },

    {
        'nvim-treesitter/nvim-treesitter',
        opts = { auto_install = { 'python' } },
        opts_extend = { 'auto_install' },
    },
}
