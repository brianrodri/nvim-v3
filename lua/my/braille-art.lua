local M = {}
local H = {}

function M.set_palette_highlights()
  local hl_by_mask = {
    ["E"] = vim.tbl_extend("force", vim.api.nvim_get_hl(0, { name = "Green" }), { bold = true }),
    ["W"] = vim.tbl_extend("force", vim.api.nvim_get_hl(0, { name = "Blue" }), { bold = true }),
    ["A"] = vim.tbl_extend("force", vim.api.nvim_get_hl(0, { name = "Normal" }), { bold = true }),
    ["F"] = vim.tbl_extend("force", vim.api.nvim_get_hl(0, { name = "Red" }), { bold = true }),
    ["#"] = { link = "NonText" },
  }

  for mask, hl in pairs(hl_by_mask) do
    vim.api.nvim_set_hl(0, H.MASK_NAMES[mask], hl)
  end
end

function M.render_text()
  local spans = {}

  for line_num = 1, #H.ART_LINES do
    if line_num > 1 then table.insert(spans, { "\n" }) end

    local mask_line = H.MASK_LINES[line_num]
    local beg_incl = 1

    while beg_incl <= #mask_line do
      local mask = mask_line:sub(beg_incl, beg_incl)
      local _, end_incl = string.find(mask_line, mask .. "+", beg_incl)
      local part = vim.fn.strcharpart(H.ART_LINES[line_num], beg_incl - 1, end_incl + 1 - beg_incl)
      table.insert(spans, { part, hl = H.MASK_NAMES[mask] })
      beg_incl = end_incl + 1
    end
  end

  return spans
end

H.ART_LINES = {
  "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣤⣤⡴⠶⠶⠶⠶⣶⠶⠶⠶⠶⠶⢦⣤⣤⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⡴⠾⠛⠋⠉⣴⣶⣦⢤⡖⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠛⠷⢦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⠞⠋⠁⠒⣄⡠⢖⠋⠻⠭⠴⠊⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⣀⣤⣶⣾⡿⠒⠈⠙⠳⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⠟⠋⣀⣀⠀⠀⢠⠏⠐⠤⠃⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⢀⣠⡴⠋⣁⡀⠛⠛⠓⢶⣶⣄⡀⠀⠙⠻⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⢠⣶⠟⠁⢀⣾⡁⠈⠳⣠⠏⣀⠤⠤⣀⠀⠀⠀⣠⢤⡀⠀⣿⠀⠀⣴⠿⠛⠛⠯⠥⢤⣀⣀⠈⢿⣿⣅⠀⠀⠀⠀⠈⠻⣶⡄⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⢀⣴⠟⠁⠀⠀⠘⠿⠃⠀⢠⡟⠋⠀⢠⠖⢀⡱⠀⠀⠣⠆⣹⠀⣿⠀⠘⠁⠀⠀⠀⠀⠀⠀⠀⠈⠙⢦⡀⠘⣿⣦⡤⠀⠀⠀⠈⠻⣦⡀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⣠⡿⠁⢀⡤⠤⣄⣀⠀⠀⢀⡟⠀⠀⠀⠀⠉⠉⠀⣠⣶⣦⠴⣿⡄⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠙⢦⢸⣿⠀⠀⠀⠀⠀⠀⠈⢿⣄⠀⠀⠀⠀",
  "⠀⠀⠀⣰⡟⠀⠀⣿⣷⣦⠀⠈⠻⣷⣾⠁⠀⠀⣀⣀⡀⠀⠀⢿⠋⠁⠀⠙⠇⣿⢠⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠇⠀⠀⢳⡹⡄⠀⠀⠀⠀⠀⠀⠀⢻⣆⠀⠀⠀",
  "⠀⠀⣰⠏⠀⠀⠀⠈⠉⠁⢀⣀⡀⠙⣿⣀⡴⠋⠁⠀⠉⠲⣄⣀⣴⡄⠀⠀⠀⣿⠘⠿⣶⣤⣀⡀⠀⠀⣀⣤⣾⠉⠀⣠⠆⠀⢹⡈⠀⠀⠀⠀⠀⠀⠹⣄⢹⣆⠀⠀",
  "⠀⢰⡟⠰⣶⣿⣷⡄⠀⡴⠁⢆⡸⠀⢹⣿⠁⡀⠀⠀⠀⠀⠈⠛⠛⠁⠀⠀⠀⣿⠀⠐⢤⣀⡭⠉⠉⠉⠽⢛⡿⢿⣾⠇⠀⢀⠀⢧⠀⠀⠀⠀⠀⠀⠀⢹⣆⢻⡆⠀",
  "⠀⣿⠁⠀⠙⠿⠿⢧⣰⠃⠀⢀⠤⢄⠈⢿⠀⢿⣦⣤⡀⠀⠀⡴⣿⣿⡆⠀⠀⣿⠀⠀⠠⢿⡀⠀⣀⡀⠀⠀⠀⠀⢹⡤⣴⣿⣦⠸⡆⠀⠘⢆⠀⠀⠀⠈⣯⠈⣿⠀",
  "⢸⡟⠀⠀⢀⡤⠤⣄⣹⣧⠀⠘⢤⣈⣀⣼⡆⠈⠻⠿⢧⡀⠀⢧⠈⠉⠀⠀⠀⣿⠀⠀⠀⣀⡽⢛⡅⠀⢀⠀⠀⠐⠋⣠⠞⠋⢙⡇⣧⠀⠀⠈⢷⣬⣶⡾⠋⠀⢻⡇",
  "⢸⡇⠀⠀⢿⡶⠀⠀⠙⢿⡆⠀⠀⠀⠀⠈⠙⢦⡀⠀⠀⣽⡗⠚⠷⣤⣤⣤⡄⣿⠰⠞⠋⠁⠈⢹⢿⣿⠃⠀⠀⠀⣼⠏⠀⠀⠈⢠⣿⠀⠀⠀⠘⣇⠈⠣⠀⠀⢸⡇",
  "⢸⡷⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⣿⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⠶⢾⡇",
  "⢸⡇⡞⠀⠀⠀⠀⠀⠀⠀⣸⡏⠀⠀⠀⠀⠀⠀⠀⠈⠻⡙⠻⢶⣄⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⡟⠀⠀⠀⠀⢠⡿⠃⠀⠀⠀⠀⢸⡇⠀⠀⠀⢸⡇",
  "⢸⣧⠹⡄⠀⠀⠀⠀⠀⢠⣿⡀⠀⠀⠀⣀⡀⠀⠀⠀⠀⢱⡀⠀⠈⠳⡄⠀⠀⣿⠀⠀⣠⡴⠖⠲⢤⡀⠀⣰⠟⠀⠀⠀⠀⣰⠏⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⣼⡇",
  "⠀⣿⡀⠘⢶⣄⡀⣠⡶⠛⠛⢷⢀⡴⠛⡟⠀⢠⣷⣄⠀⠈⡇⠀⠀⠀⠙⣆⠀⣿⢀⡞⠁⣴⢋⡷⠀⣿⣾⠏⠀⠀⠀⣠⡾⠋⣠⠖⠒⢦⡀⠀⠀⢀⡇⠀⠀⢀⣿⠀",
  "⠀⠸⣧⠀⠀⢈⣿⢋⡀⠀⢀⡾⠋⠀⢸⣧⡴⠟⠉⢻⡆⠀⡇⠀⠀⠀⠀⠘⡆⣿⠸⠀⠀⠙⠦⠤⠴⠋⠁⠀⢀⣤⡾⠋⠀⣼⠃⠀⡔⢀⣿⠀⠀⣸⠁⠀⠀⣼⠇⠀",
  "⠀⠀⠹⣇⠀⣾⠃⠈⠻⣄⣾⠁⠀⠀⠈⣿⡀⠀⠀⡼⢁⡼⠁⠀⠀⠀⠀⠀⠀⣿⢠⠞⣩⣍⠓⢦⠀⢀⣴⠞⠋⠁⠀⠀⠀⢿⠀⠀⠙⠛⠁⠀⣰⠋⠀⠀⣸⠏⠀⠀",
  "⠀⠀⠀⠹⣧⠻⠀⢰⡀⣸⡇⠀⠀⠀⠀⠈⠻⢦⣤⠴⠊⢠⠀⠀⠀⠀⠀⠀⠀⣿⠘⢦⣑⣠⠇⣬⡶⠋⠁⠀⠀⠀⠀⠀⠀⠈⠳⠤⢤⣤⠤⠚⠁⠀⠀⣼⠏⠀⠀⠀",
  "⠀⠀⠀⠀⠙⣷⡀⠀⢻⡟⠻⣄⠀⠀⠀⠀⠀⢠⡆⠀⠀⢠⣧⠀⠀⠀⠀⠀⡄⣿⠀⠀⠀⢀⣾⡿⠁⠀⣠⣶⡿⠿⠿⣷⣄⠀⡴⠋⣉⣈⠉⢢⡀⢀⣾⠋⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠈⠻⣦⡀⠙⠦⣌⣳⡀⠀⠀⠀⠘⠑⠀⢀⣾⣿⡆⠀⠀⠀⣰⠃⣿⠀⠀⠀⢸⣿⠁⠀⢰⣿⣏⠐⣢⠀⠈⢻⣾⠀⡞⠡⣆⡵⢀⣴⠟⠁⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠘⠿⣦⡀⠀⠉⠳⣄⣀⣼⡄⠀⣠⣿⣿⣿⡇⠀⢀⣴⣃⠄⣿⠀⠀⠀⠈⢿⣧⣀⠀⠙⠿⠟⠋⠀⢀⣼⠇⠀⠳⡄⢀⣴⠿⠃⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣦⣄⠀⠈⠋⡹⠃⢰⡟⠉⢻⡿⠁⠴⠛⠋⠁⠀⣿⢀⣀⠀⠀⠀⠙⠿⣷⣦⣤⣤⣤⠾⠋⠁⠀⠀⣠⣴⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⢦⣄⡀⠀⠘⢇⠀⠘⠁⠀⠀⠀⠀⢀⡄⣿⠈⠉⠙⠓⠶⣄⠀⠀⠀⠀⠀⠀⠀⢀⣠⡴⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠳⢶⣤⣄⣀⠒⠤⠤⡴⠒⠉⡀⣿⢠⣄⠀⠀⠀⠈⠷⠀⣀⣠⣤⡶⠞⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠛⠛⠳⠶⠶⠶⠶⠿⠶⠶⠶⠶⠶⠞⠛⠛⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
}

H.MASK_LINES = {
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

H.MASK_NAMES = {
  ["E"] = "NorthWestEarthVines",
  ["W"] = "NorthEastWaterWaves",
  ["A"] = "SouthEastAirSpirals",
  ["F"] = "SouthWestFireFlames",
  ["#"] = "BorderSeparator",
}

return M
