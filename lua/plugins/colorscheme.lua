return {
    {
        'sainnhe/everforest',
        lazy = false,
        priority = 1000,
        config = function()
            vim.o.background = 'dark'
            vim.g.everforest_background = 'hard'
            vim.g.everforest_enable_italic = true
            vim.g.everforest_better_performance = 1
            vim.g.everforest_transparent_background = 2

            vim.api.nvim_create_autocmd('ColorScheme', {
                group = vim.api.nvim_create_augroup('my.everforest_highlights', {}),
                pattern = 'everforest',
                callback = function()
                    local config = vim.fn['everforest#get_configuration']()
                    local palette = vim.fn['everforest#get_palette'](config.background, config.colors_override)
                    local set_hl = vim.fn['everforest#highlight']

                    -- NOTE: Personalized colors for dashboard
                    set_hl('SnacksDashboardHeader', palette.green, palette.none)
                    set_hl('SnacksDashboardIcon', palette.green, palette.none)
                    set_hl('SnacksDashboardDesc', palette.fg, palette.none)
                    set_hl('SnacksDashboardKey', palette.green, palette.none)
                    set_hl('SnacksDashboardFooter', palette.grey0, palette.none)
                    set_hl('SnacksDashboardSpecial', palette.green, palette.none)
                    set_hl('SnacksDashboardDir', palette.grey0, palette.none)
                    set_hl('SnacksDashboardFile', palette.fg, palette.none)
                    set_hl('SnacksDashboardTerminal', palette.fg, palette.none)
                    set_hl('SnacksDashboardTitle', palette.green, palette.none)
                end,
            })

            vim.cmd.colorscheme('everforest')
        end,
    },
}
