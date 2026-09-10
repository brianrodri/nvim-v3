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
  ---@module "snacks"
  ---@type snacks.dashboard.Text[]
  local dashboard_parts = {}
  for y = 1, #H.ART_LINES do
    for hl_mask, hl_beg_incl, hl_end_excl in H.scan_for_duplicate_chars(H.MASK_LINES[y]) do
      local art_part = vim.fn.strcharpart(H.ART_LINES[y], hl_beg_incl, hl_end_excl - hl_beg_incl)
      table.insert(dashboard_parts, { art_part, hl = H.MASK_NAMES[hl_mask] })
    end
    if y < #H.ART_LINES then table.insert(dashboard_parts, { "\n" }) end
  end
  return dashboard_parts
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

function H.scan_for_duplicate_chars(line)
  local x_pos, x_end = 1, #line
  return function()
    if x_pos > x_end then return end
    local mask = line:sub(x_pos, x_pos)
    local pos_beg_incl, pos_end_incl = string.find(line, mask .. "+", x_pos)
    x_pos = pos_end_incl + 1
    return mask, pos_beg_incl - 1, pos_end_incl
  end
end

return M
