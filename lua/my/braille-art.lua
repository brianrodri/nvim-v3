--- Public API for rendering my braille-ascii art.
local M = {}
--- Private helpers and data for organizing the code.
local H = {}

--- Mutates the highlight groups I use to style my art. This function is idempotent.
function M.set_palette_highlights()
  for mask, name in pairs(H.MASK_NAMES) do
    vim.api.nvim_set_hl(0, name, H.MASK_PALETTES[mask])
  end
end

---@module 'snacks'
---@return snacks.dashboard.Text[] art a flat list of styled text.
function M.get_text_definition()
  return vim.iter(H.ART_LINES):enumerate():fold({}, function(spans, row, line)
    if row ~= 1 then table.insert(spans, { "\n" }) end

    for col, glyph in ipairs(vim.fn.split(line, "\\zs")) do
      local cell_hl = H.get_cell_highlight_group(row, col)
      local prev_span = spans[#spans]
      if prev_span and prev_span.hl == cell_hl then
        prev_span[1] = prev_span[1] .. glyph
      else
        table.insert(spans, { glyph, hl = cell_hl })
      end
    end

    return spans
  end)
end

H.ART_LINES = {
  "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣤⣤⡴⠶⠶⠶⠶⣶⠶⠶⠶⠶⠶⢦⣤⣤⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⡴⠾⠛⠋⠉⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠛⠷⢦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⠞⠋⠁⠐⣄⡠⠮⠋⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⣀⣤⣶⣾⡿⠒⠈⠙⠳⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⠟⠋⢀⣀⠀⠀⢠⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⢀⣠⡴⠋⣁⡀⠛⠛⠓⢶⣶⣄⡀⠀⠙⠻⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⢠⣶⠟⠁⢀⣾⡁⠀⠑⣤⣏⣀⣀⣀⡀⠀⠀⠀⢀⡀⠀⠀⣿⠀⠀⣴⠿⠛⠛⠯⠥⢤⣀⣀⠈⢿⣿⣅⠀⠀⠀⠀⠈⠻⣶⡄⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⢀⣴⠟⠁⠀⠀⠈⠿⠃⠀⢠⠟⠁⠀⢠⠖⢈⡱⠀⢾⣿⡀⠀⠀⣿⠀⠘⠁⠀⠀⠀⠀⠀⠀⠀⠈⠙⢦⡀⠘⣿⣦⡤⠀⠀⠀⠈⠻⣦⡀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⣠⡿⠁⢀⡤⠤⣄⣀⠀⠀⠀⡞⠀⠀⠀⠀⠉⠉⠀⠀⠀⠉⠳⣄⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠙⢦⢸⣿⠀⠀⠀⠀⠀⠀⠈⢿⣄⠀⠀⠀⠀",
  "⠀⠀⠀⣰⡟⠀⠀⣿⣷⣦⠀⠈⠻⣷⣾⠃⠀⠀⣀⣀⠀⠀⠀⠀⠀⠊⠙⠻⡇⣿⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠇⠀⠀⢳⡹⡄⠀⠀⠀⠀⠀⠀⠀⢻⣆⠀⠀⠀",
  "⠀⠀⣰⡏⠀⠀⠀⠈⠉⠁⢀⣀⡀⠙⣿⣀⡴⠋⠁⠈⠉⠲⣄⣠⣷⡄⠀⠀⠀⣿⠘⠿⣷⣦⣀⡀⠀⠀⣀⣤⣾⠉⠀⣠⠆⠀⢹⡈⠀⠀⠀⠀⠀⠀⠹⣄⢹⣆⠀⠀",
  "⠀⢰⡟⠰⣾⣿⣷⡄⠀⡼⠁⣖⣸⠀⢹⣿⠁⡀⠀⠀⠀⠀⠈⠛⠛⠁⠀⠀⠀⣿⠀⠐⢤⣠⠭⠉⠉⠉⠽⢛⡿⢿⣾⠇⠀⢀⠀⢧⠀⠀⠀⠀⠀⠀⠀⢹⣆⢻⡆⠀",
  "⠀⣿⠁⠀⠻⠿⠿⢇⢀⠇⠀⢀⡤⣄⠈⢿⠀⢸⣤⣄⡀⠀⠀⠀⣾⣿⠇⠀⠀⣿⠀⠀⠠⢽⡀⠀⣀⡀⠀⠀⠀⠀⢹⡤⣴⣿⣦⣸⡄⠀⠘⢆⠀⠀⠀⠈⣯⠈⣿⠀",
  "⢸⡟⠀⠀⣀⡤⠤⣬⣽⣧⠀⠘⠦⣌⣀⣘⡆⠀⠻⠿⠿⣄⢀⡜⠈⠁⢀⡀⠀⣿⠀⠀⠀⣀⡼⢛⡅⠀⢀⠀⠀⠐⠋⢀⡞⠋⢙⡇⣧⠀⠀⠈⢷⣽⣶⡾⠋⠀⢻⡇",
  "⢸⡇⠀⠀⢿⡀⠀⠀⠙⢿⡄⠀⠀⣀⠀⣈⠙⢦⡀⠀⢀⡼⠋⠀⠀⠀⠈⠛⠄⣿⠠⠔⠊⠁⠈⢹⢿⣿⠃⠀⠀⢀⡴⠋⠀⠀⠈⢠⣿⠀⠀⠀⠘⣟⠙⢧⠀⠀⢸⡇",
  "⢸⡷⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⣿⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⢾⡇",
  "⢸⡇⡍⠀⠀⠀⠀⠀⠀⠀⢸⡟⠀⠀⠀⠀⠀⠀⠀⠈⢳⡄⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⠇⠀⠀⠀⠀⢠⡿⠃⠀⠀⠀⠀⢸⡇⠀⠀⠀⢸⡇",
  "⢸⣧⠹⡄⠀⠀⠀⠀⠀⢠⣿⡇⠀⠀⠀⠀⣀⠀⠀⠀⠀⢳⡀⠀⠀⡎⠀⠀⠀⣿⠀⠀⣠⡴⠖⠒⢤⡀⠀⣰⠏⠀⠀⠀⠀⣰⠏⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⣼⡇",
  "⠀⣿⡀⠘⠦⣄⡀⣠⠴⠛⠛⢷⠀⢀⡴⡟⠁⢀⣷⡄⠀⠈⡇⠀⠀⠙⢦⣄⡀⣿⢠⠞⠁⣴⠫⠷⠀⣿⣾⠏⠀⠀⠀⣠⡾⠋⣠⠖⠒⢦⡀⠀⠀⢠⡇⠀⠀⢀⣿⠀",
  "⠀⠸⣧⠀⠀⠘⣿⢏⠀⠀⠀⠈⡷⠋⢠⡇⣠⠞⠉⢻⠀⠀⡇⠀⠀⠀⠀⠈⠁⣿⠀⠀⠀⠙⠦⠤⠴⠋⠁⠀⢀⣤⡾⠋⠀⣼⠃⠀⡔⢀⣿⠀⠀⣸⠁⠀⠀⣼⠇⠀",
  "⠀⠀⠹⣇⠀⣰⠃⠈⠹⡄⠀⡞⠁⠀⠘⣿⡁⠀⠀⡼⢀⡼⠁⠀⠀⠀⠀⠀⠀⣿⢠⠞⠉⠑⢦⡀⠀⢀⣴⠞⠉⠁⠀⠀⠀⢿⠀⠀⠙⠛⠁⠀⣰⠋⠀⠀⣸⠏⠀⠀",
  "⠀⠀⠀⠹⣧⠩⠀⠀⣄⣿⣼⡇⠀⠀⠀⠈⠻⠦⣤⠵⠊⢠⠀⠀⠀⠀⠀⠀⠀⣿⠘⠦⠔⠀⠈⣿⡶⠋⠁⠀⠀⠀⠀⠀⠀⠈⠳⠤⢤⣤⠤⠚⠁⠀⠀⣼⠏⠀⠀⠀",
  "⠀⠀⠀⠀⠙⣷⡀⠀⠘⣿⡏⢯⠀⠀⠀⠀⠀⢀⣇⠀⠀⢠⣧⠀⠀⠀⠀⠀⠀⣿⠠⢤⣀⣠⣾⡿⠁⠀⣠⣶⡿⠿⠿⣷⣄⠀⡴⠋⣉⣈⠉⢢⡀⢀⣾⠋⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠈⠻⣦⡀⢿⠳⢬⣷⣆⠀⠀⢠⠘⠈⠀⢀⣾⣿⡆⠀⠀⠀⣰⠃⣿⠀⠀⠀⠉⣿⡃⠀⢰⣿⣏⠐⣢⠀⠈⢻⣾⠀⡞⠡⣆⡵⢀⣴⠟⠁⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠘⠿⣦⡀⠀⠙⢿⣧⣀⣸⡄⠀⣠⣿⣿⣿⡇⠀⢀⡴⣃⠀⣿⠀⠀⠀⠀⢸⣧⣀⠀⠙⠿⠟⠋⠀⢀⣼⠇⠀⠳⡄⢀⣴⠿⠃⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣦⣄⠀⠸⠋⢹⠃⢰⡿⠋⢻⡿⠡⠴⠛⠉⠁⠁⣿⠠⣀⠀⠀⠀⠙⠿⣷⣦⣤⣤⣤⠾⠋⠁⠀⠀⣠⣴⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⢦⣄⡀⠀⠘⣇⠠⠞⠁⠀⠀⠀⠀⢀⡄⣿⠀⠈⠉⠒⠶⣄⠀⠀⠀⠀⠀⠀⠀⢀⣠⡴⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠳⢶⣤⣄⣀⠀⠠⠤⡴⠒⠉⡀⣿⢠⣄⠀⠀⠀⠈⠷⠀⣀⣠⣤⡶⠞⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠛⠛⠳⠶⠶⠶⠶⠿⠶⠶⠶⠶⠶⠞⠛⠛⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
}

H.MASK_NAMES = {
  ["E"] = "NorthWestEarthVines",
  ["W"] = "NorthEastWaterWaves",
  ["A"] = "SouthEastAirSpirals",
  ["F"] = "SouthWestFireFlames",
  ["#"] = "BorderSeparator",
}

H.MASK_PALETTES = {
  ["E"] = { fg = "#5CB01C" },
  ["W"] = { fg = "#29ABE2" },
  ["A"] = { fg = "#CBDDF5" },
  ["F"] = { fg = "#F26522" },
  ["#"] = { link = "NonText" },
}

H.MASK_STRINGS = {
  "############################################################",
  "######################EEEEEEE#WWWWWWWW######################",
  "#################EEEEEEEEEEEE#WWWWWWWWWWWWW#################",
  "#############EEEEEEEEEEEEEEEE#WWWWWWWWWWWWWWWWW#############",
  "###########EEEEEEEEEEEEEEEEEE#WWWWWWWWWWWWWWWWWWW###########",
  "#########EEEEEEEEEEEEEEEEEEEE#WWWWWWWWWWWWWWWWWWWWW#########",
  "#######EEEEEEEEEEEEEEEEEEEEEE#WWWWWWWWWWWWWWWWWWWWWWW#######",
  "#####EEEEEEEEEEEEEEEEEEEEEEEE#WWWWWWWWWWWWWWWWWWWWWWWWW#####",
  "####EEEEEEEEEEEEEEEEEEEEEEEEE#WWWWWWWWWWWWWWWWWWWWWWWWWW####",
  "###EEEEEEEEEEEEEEEEEEEEEEEEEE#WWWWWWWWWWWWWWWWWWWWWWWWWWW###",
  "###EEEEEEEEEEEEEEEEEEEEEEEEEE#WWWWWWWWWWWWWWWWWWWWWWWWWWW###",
  "##EEEEEEEEEEEEEEEEEEEEEEEEEEE#WWWWWWWWWWWWWWWWWWWWWWWWWWWW##",
  "##EEEEEEEEEEEEEEEEEEEEEEEEEEE#WWWWWWWWWWWWWWWWWWWWWWWWWWWW##",
  "############################################################",
  "##FFFFFFFFFFFFFFFFFFFFFFFFFFF#AAAAAAAAAAAAAAAAAAAAAAAAAAAA##",
  "##FFFFFFFFFFFFFFFFFFFFFFFFFFF#AAAAAAAAAAAAAAAAAAAAAAAAAAAA##",
  "###FFFFFFFFFFFFFFFFFFFFFFFFFF#AAAAAAAAAAAAAAAAAAAAAAAAAAA###",
  "###FFFFFFFFFFFFFFFFFFFFFFFFFF#AAAAAAAAAAAAAAAAAAAAAAAAAAA###",
  "####FFFFFFFFFFFFFFFFFFFFFFFFF#AAAAAAAAAAAAAAAAAAAAAAAAAA####",
  "#####FFFFFFFFFFFFFFFFFFFFFFFF#AAAAAAAAAAAAAAAAAAAAAAAAA#####",
  "#######FFFFFFFFFFFFFFFFFFFFFF#AAAAAAAAAAAAAAAAAAAAAAA#######",
  "#########FFFFFFFFFFFFFFFFFFFF#AAAAAAAAAAAAAAAAAAAAA#########",
  "###########FFFFFFFFFFFFFFFFFF#AAAAAAAAAAAAAAAAAAA###########",
  "#############FFFFFFFFFFFFFFFF#AAAAAAAAAAAAAAAAA#############",
  "#################FFFFFFFFFFFF#AAAAAAAAAAAAA#################",
  "######################FFFFFFF#AAAAAAAA######################",
  "############################################################",
}

function H.get_cell_highlight_group(row, col)
  local mask = assert(H.MASK_STRINGS[row]:sub(col, col))
  local name = assert(H.MASK_NAMES[mask])
  return name
end

return M
