dofile("nvim/lua/config/commands.lua")

local notices = {}
vim.notify = function(message)
  table.insert(notices, message)
end

local function lines()
  return vim.api.nvim_buf_get_lines(0, 0, -1, false)
end

vim.api.nvim_buf_set_lines(0, 0, -1, false, { '{"answer":42}' })
vim.cmd("PrettyJSON")
assert(vim.deep_equal(lines(), { "{", '    "answer": 42', "}" }), "Valid JSON should be formatted")

local invalid = { "{invalid JSON", "keep this line" }
vim.api.nvim_buf_set_lines(0, 0, -1, false, invalid)
local tick = vim.api.nvim_buf_get_changedtick(0)
vim.cmd("PrettyJSON")
assert(vim.deep_equal(lines(), invalid), "Invalid JSON must leave the buffer intact")
assert(vim.api.nvim_buf_get_changedtick(0) == tick, "Failed formatting must not modify undo history")
assert(#notices == 1 and notices[1]:find("json.tool failed", 1, true), "Failure should be reported")

local system = vim.system
vim.system = function()
  error("executable unavailable")
end
vim.cmd("PrettyJSON")
vim.system = system
assert(vim.deep_equal(lines(), invalid), "A missing formatter must leave the buffer intact")
assert(#notices == 2, "A missing formatter should be reported")
print("PrettyJSON checks passed")
vim.cmd("qa!")
