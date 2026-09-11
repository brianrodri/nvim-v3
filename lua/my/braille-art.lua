local M = {}
local H = {}

function M.render_text()
  ---@module "snacks"
  ---@type snacks.dashboard.Text[]
  local dashboard_parts = {}
  for y = 1, #H.ART_LINES do
    for mask, beg_incl, end_excl in H.group_consecutive_chars(H.MASK_LINES[y]) do
      local art_part = vim.fn.strcharpart(H.ART_LINES[y], beg_incl, end_excl - beg_incl)
      table.insert(dashboard_parts, { art_part, hl = H.HL_BY_MASK[mask] })
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

H.HL_BY_MASK = {
  ["E"] = "DiagnosticOk",
  ["W"] = "DiagnosticInfo",
  ["F"] = "DiagnosticError",
  ["A"] = "Normal",
  ["#"] = "NonText",
}

function H.group_consecutive_chars(line)
  local mut_beg_pos = 1
  return function()
    if mut_beg_pos > #line then return end
    local mask = line:sub(mut_beg_pos, mut_beg_pos)
    local beg_pos, end_pos = string.find(line, mask .. "+", mut_beg_pos)
    mut_beg_pos = end_pos + 1
    return mask, beg_pos - 1, end_pos
  end
end

return M
