return {
    {
        'neovim/nvim-lspconfig',
        opts = { ['ts_ls'] = true },
    },

    {
        'mfussenegger/nvim-lint',
        opts = {
            javascript = { 'eslint' },
            javascriptreact = { 'eslint' },
            typescript = { 'eslint' },
            typescriptreact = { 'eslint' },
        },
    },

    {
        'nvim-treesitter/nvim-treesitter',
        opts = { auto_install = { 'tsx', "typescript" } },
        opts_extend = { 'auto_install' },
    },

    {
        'mxsdev/nvim-dap-vscode-js',
    },
}
