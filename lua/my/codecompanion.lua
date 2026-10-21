local M = {}

--- Places the chat window on the right when the terminal is wider than it is tall, and on the bottom otherwise.
---
--- The window config is read on every open, so this only affects chats opened after it runs.
--- Cells are roughly twice as tall as they are wide, hence the factor of 2.
function M.update_chat_window()
  local window = require("codecompanion.config").display.chat.window
  if vim.o.columns > 2 * vim.o.lines then
    window.layout, window.position = "vertical", "right"
  else
    window.layout, window.position = "horizontal", "bottom"
  end
end

return M
