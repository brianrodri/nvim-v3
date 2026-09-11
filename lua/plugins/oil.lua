local git_symbols = require("my.icons").git_symbols

local GIT_SYMBOLS = {
  { "A", index = git_symbols.added, working_tree = git_symbols.added },
  { "C", index = git_symbols.copied, working_tree = git_symbols.copied },
  { "D", index = git_symbols.removed, working_tree = git_symbols.removed },
  { "M", index = git_symbols.modified, working_tree = git_symbols.modified },
  { "R", index = git_symbols.renamed, working_tree = git_symbols.renamed },
  { "T", index = git_symbols.type_changed, working_tree = git_symbols.type_changed },
  { "U", index = git_symbols.unmerged, working_tree = git_symbols.unmerged },
  -- NOTE: git reports untracked entries as `??`, i.e. the same code in both the index and working
  -- tree columns, so blank the index side to show the icon only once.
  { "?", index = " ", working_tree = git_symbols.untracked },
}

local GIT_HIGHLIGHTS = {
  { "Added", index = "GitSignsStagedAdd", working_tree = "GitSignsAdd" },
  { "Copied", index = "GitSignsStagedAdd", working_tree = "GitSignsAdd" },
  { "Deleted", index = "GitSignsStagedDelete", working_tree = "GitSignsDelete" },
  { "Modified", index = "GitSignsStagedChange", working_tree = "GitSignsChange" },
  { "Renamed", index = "GitSignsStagedChange", working_tree = "GitSignsChange" },
  { "TypeChanged", index = "GitSignsStagedChange", working_tree = "GitSignsChange" },
  { "Untracked", index = "GitSignsStagedUntracked", working_tree = "GitSignsUntracked" },
}

return {
  {
    "stevearc/oil.nvim",
    opts = {
      view_options = { show_hidden = true },
      win_options = { signcolumn = "auto:2" },
    },
  },

  {
    "refractalize/oil-git-status.nvim",
    dependencies = { "stevearc/oil.nvim" },
    opts = { show_ignored = false },
    config = function(_, opts)
      opts = vim.tbl_deep_extend("keep", opts or {}, { symbols = { index = {}, working_tree = {} } })

      for _, entry in ipairs(GIT_SYMBOLS) do
        opts.symbols.index[entry[1]] = entry.index
        opts.symbols.working_tree[entry[1]] = entry.working_tree
      end

      require("oil-git-status").setup(opts)

      for _, entry in ipairs(GIT_HIGHLIGHTS) do
        vim.api.nvim_set_hl(0, "OilGitStatusIndex" .. entry[1], { link = entry.index })
        vim.api.nvim_set_hl(0, "OilGitStatusWorkingTree" .. entry[1], { link = entry.working_tree })
      end
    end,
  },
}
