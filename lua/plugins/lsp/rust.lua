return {
    {
        'neovim/nvim-lspconfig',
        opts = {
            ['rust_analyzer'] = true,
        },
    },

    {
        'nvim-treesitter/nvim-treesitter',
        opts = { auto_install = { 'rust' } },
        opts_extend = { 'auto_install' },
    },
}
