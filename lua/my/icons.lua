return {
  readonly = "󰌾",
  modified = "󰏫",
  close = "󱎘",

  -- NOTE: Octicons carry a purpose-built diff family, so git status keeps that set rather than
  -- the `nf-md-*` glyphs used everywhere else.
  git_symbols = {
    added = "",
    modified = "",
    removed = "",
    copied = "",
    renamed = "",
    type_changed = "",
    unmerged = "",
    untracked = "",
    ignored = "",
  },

  diagnostics = {
    error = "󰅙",
    warn = "󰀦",
    info = "󰋼",
    hint = "󰌵",
  },

  separator = {
    left = "",
    right = "",
  },

  file = "󰝰",
  branch = "󰘬",
  lsp = "󰣖",
  progress = "󰏰",

  keymaps = "󰌌",
  projects = "󰉓",
  recent = "󱋡",
  new_file = "󰝒",
  find_file = "󰱼",
  find_config = "󱁻",
  find_text = "󱎸",
  git = "󰊢",
  lazy = "󰒲",
  quit = "󰈆",
  vault = "",
  code = "󰅩",
  hunk = "󰢪",
  change_base = "󱒒",
}
