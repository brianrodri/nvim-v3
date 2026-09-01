return {
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
    },

    {
        "obsidian-nvim/obsidian.nvim",
        opts = {
            legacy_commands = false,
            workspaces = {
                {
                    name = "z-vault",
                    path = "~/Documents/z-vault",
                },
            },
        },
    },
}
