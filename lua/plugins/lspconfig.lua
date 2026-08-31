return {
    {
        'neovim/nvim-lspconfig',
        lazy = false,
        opts = {
            ['*'] = {
                capabilities = {
                    codeLensProvider = true,
                    workspace = { fileOperations = { didRename = true, willRename = true } },
                },
            },
        },
        config = function(_, opts)
            for name, cfg in pairs(opts) do
                vim.lsp.config(name, type(cfg) == 'table' and cfg or {})
                if name ~= '*' then vim.lsp.enable(name, cfg) end
            end
        end,
    },

    { import = 'plugins.lsp' },

    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ':TSUpdate',
        config = function(_, opts)
            local nvim_treesitter = require('nvim-treesitter')
            nvim_treesitter.setup(opts)
            nvim_treesitter.install(opts.auto_install or {})
        end,
    }
}
