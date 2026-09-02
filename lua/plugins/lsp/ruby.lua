return {
    {
        'neovim/nvim-lspconfig',
        opts = { ['solargraph'] = true },
    },

    {
        'nvim-treesitter/nvim-treesitter',
        opts = { auto_install = { 'ruby' } },
        opts_extend = { 'auto_install' },
    },
}
