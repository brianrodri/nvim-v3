return {
    {
        'folke/which-key.nvim',
        opts = { preset = 'helix' },
        dependencies = {
            { 'nvim-mini/mini.icons', version = false },
            { 'nvim-tree/nvim-web-devicons', version = false },
        },
        lazy = false,
        config = true,
    },

    {
        'nvim-lualine/lualine.nvim',
        opts = { theme = 'everforest' },
    },

    {
        'folke/noice.nvim',
        opts = {
            lsp = {
                override = {
                    ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                    ['vim.lsp.util.stylize_markdown'] = true,
                },
            },
            presets = {
                inc_rename = true,
                lsp_doc_border = true,
            },
        },
        dependencies = {
            'MunifTanjim/nui.nvim',
            'nvim-mini/mini.notify',
            {
                'nvim-treesitter/nvim-treesitter',
                opts = { auto_install = { 'regex', 'bash' } },
                opts_extend = { 'auto_install' },
            },
        },
    },

    {
        'onsails/lspkind.nvim',
        opts = { mode = 'symbol_text' },
    },

    {
        'folke/snacks.nvim',
        dependencies = {
            {
                'nvim-treesitter/nvim-treesitter',
                opts = { auto_install = { 'css', 'html', 'javascript', 'latex', 'norg', 'scss', 'svelte', 'tsx', 'typst', 'vue' } },
                opts_extend = { 'auto_install' },
            },
        },
    },
}
