local my_prefs = require("my.obsidian-prefs")

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
        ---@module 'obsidian'
        ---@type obsidian.config
        opts = {
            legacy_commands = false, -- TODO: Remove this setting in 4.0.0 release

            workspaces = {
                {
                    name = "vault",
                    path = "~/Documents/vault",
                    ---@type {}
                    overrides = {
                        notes_subdir = "01-inbox",
                        new_notes_location = "current_dir",
                        attachments = { folder = "99-meta/attachments" },
                        daily_notes = { folder = "02-periodic/01-daily" },
                        unique_note = { folder = "01-inbox" },
                    },
                },
            },

            ui = { enable = false },
            daily_notes = { enabled = true, workdays_only = false },
            unique_note = { enabled = true, format = my_prefs.task_notes_adapter },
            note_id_func = my_prefs.task_notes_adapter,

            frontmatter = {
                func = my_prefs.task_notes_frontmatter_adapter,
                sort = { "title", "status", "priority", "scheduled", "dateCreated", "dateModified", "startDate", "id", "aliases", "kind", "tags" },
            },
        },
    },
}
