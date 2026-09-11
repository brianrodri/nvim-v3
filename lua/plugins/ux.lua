return {
  {
    "folke/which-key.nvim",
    opts = { preset = "helix" },
    dependencies = { "nvim-mini/mini.icons" },
    lazy = false,
    config = true,
  },

  {
    "nvim-mini/mini.icons",
    version = false,
    -- NOTE: mini.icons draws filetype and LSP-kind icons from the same `nf-md-*` Nerd Font
    -- set as my.icons, while nvim-web-devicons prefers `nf-dev-*`. Mocking the latter routes
    -- every consumer through mini.icons, so tab and picker icons match the palette.
    -- The mock has to land in `package.loaded` before nvim-cokeline is required, because
    -- its buffers.lua caches the module at load time; hence loading eagerly at priority.
    lazy = false,
    priority = 100,
    config = function(_, opts)
      local mini_icons = require("mini.icons")
      mini_icons.setup(opts)
      mini_icons.mock_nvim_web_devicons()
    end,
  },

  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
      presets = {
        inc_rename = true,
        lsp_doc_border = true,
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-mini/mini.notify",
      {
        "nvim-treesitter/nvim-treesitter",
        opts = { auto_install = { "regex", "bash" } },
        opts_extend = { "auto_install" },
      },
    },
  },

  {
    "onsails/lspkind.nvim",
    opts = { mode = "symbol_text" },
  },

  {
    "folke/snacks.nvim",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter",
        opts = {
          auto_install = { "css", "html", "javascript", "latex", "scss", "svelte", "tsx", "typst", "vue" },
        },
        opts_extend = { "auto_install" },
      },
    },
  },
}
