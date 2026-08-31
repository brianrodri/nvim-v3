return {
    {
        'neovim/nvim-lspconfig',
        opts = { ['pyright'] = true },
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

    {
        'mfussenegger/nvim-dap-python',
        config = function() require("dap-python").setup("python3") end,
    },
}
