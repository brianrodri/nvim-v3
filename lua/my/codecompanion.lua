local M = {}

--- Height of a terminal cell divided by its width (20 x 45 px measured).
local CELL_ASPECT_RATIO = 45.0 / 20.0 -- 2.25

--- Places the chat window on the right when the terminal is wider than it is
--- tall, and on the bottom otherwise.
---
--- The window config is read on every open, so this only affects chats opened
--- after it runs. Cells are taller than they are wide, so the line count is
--- scaled by CELL_ASPECT_RATIO to compare the window's actual pixel dimensions.
function M.update_chat_window()
  local window = require("codecompanion.config").display.chat.window
  if vim.o.columns > CELL_ASPECT_RATIO * vim.o.lines then
    window.layout, window.position = "vertical", "right"
  else
    window.layout, window.position = "horizontal", "bottom"
  end
end

return M
