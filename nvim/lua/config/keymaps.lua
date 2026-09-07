local map = vim.keymap.set

-- Tabs
map("n", "<leader>n", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader>k", "<cmd>tabclose<cr>", { desc = "Close tab" })
map("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "Close other tabs" })
map("n", "]v", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "[v", "<cmd>tabprevious<cr>", { desc = "Previous tab" })
map("n", "]V", "<cmd>tablast<cr>", { desc = "Last tab" })
map("n", "[V", "<cmd>tabfirst<cr>", { desc = "First tab" })

-- Windows
map("n", "<C-w>q", "<C-W>c", { desc = "Close window" })
map("n", "<C-n>", "<C-W>n", { desc = "New window" })
map("n", "<C-W>z", "<cmd>wincmd z<bar>cclose<bar>lclose<cr>", { desc = "Close preview/qf/loc" })
map("n", "<leader>v", "<C-w>v", { silent = true, desc = "Split vertical" })
map("n", "<leader>s", "<C-w>s", { silent = true, desc = "Split horizontal" })
map("n", "<leader>V", "<c-w>t<c-w>H", { silent = true, desc = "Layout vertical" })
map("n", "<leader>H", "<c-w>t<c-w>K", { silent = true, desc = "Layout horizontal" })

-- Window resizing (uses ResizeWindow from commands.lua)
map("n", "<Left>", function()
  require("config.commands").resize_window("h")
end, { silent = true, desc = "Resize left" })
map("n", "<Right>", function()
  require("config.commands").resize_window("l")
end, { silent = true, desc = "Resize right" })
map("n", "<Up>", function()
  require("config.commands").resize_window("k")
end, { silent = true, desc = "Resize up" })
map("n", "<Down>", function()
  require("config.commands").resize_window("j")
end, { silent = true, desc = "Resize down" })

-- Buffers
map("n", "<leader>bd", "<cmd>bd<cr>", { silent = true, desc = "Delete buffer" })
map("n", "<leader>bw", function()
  require("config.commands").wipeout(false)
end, { silent = true, desc = "Wipeout buffer" })
map("n", "<leader>bo", function()
  require("config.commands").buf_only()
end, { silent = true, desc = "Close other buffers" })
map("n", "<leader>bc", function()
  require("config.commands").buf_only()
  vim.cmd("bd")
end, { silent = true, desc = "Close all buffers" })

-- Fast save
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>W", "<cmd>Wall<cr>", { desc = "Save all" })
map("n", "<leader>S", "<cmd>SudoWrite<cr>", { desc = "Sudo save" })

-- Settings toggles
map("n", "yoe", "<cmd>set expandtab!<bar>set expandtab?<cr>", { desc = "Toggle expandtab" })
map("n", "yom", "<cmd>Matches<cr>", { desc = "Show match count" })
map("n", "<leader>h", "<cmd>nohlsearch<cr>", { silent = true, desc = "Clear search highlight" })

-- Command line (readline style)
map("c", "<C-a>", "<Home>", { desc = "Beginning of line" })
map("c", "<C-b>", "<Left>", { desc = "Char left" })
map("c", "<C-f>", "<Right>", { desc = "Char right" })
map("c", "<C-d>", "<Delete>", { desc = "Delete char" })
map("c", "<M-b>", "<S-Left>", { desc = "Word left" })
map("c", "<M-f>", "<S-Right>", { desc = "Word right" })
map("c", "<M-d>", "<S-right><Delete>", { desc = "Delete word" })
map("c", "<C-g>", "<C-c>", { desc = "Abort" })
map("c", "<C-p>", "<Up>", { desc = "Previous history" })
map("c", "<C-n>", "<Down>", { desc = "Next history" })

-- Search
map("n", "&", "<cmd>&&<cr>", { desc = "Repeat substitute with flags" })

-- German keyboard: ö → [, ä → ]
for c = 65, 90 do
  local ch = string.char(c)
  map({ "n", "x", "o" }, "ö" .. ch, "[" .. ch, { remap = true, desc = "[" .. ch })
  map({ "n", "x", "o" }, "ä" .. ch, "]" .. ch, { remap = true, desc = "]" .. ch })
end
for c = 97, 122 do
  local ch = string.char(c)
  map({ "n", "x", "o" }, "ö" .. ch, "[" .. ch, { remap = true, desc = "[" .. ch })
  map({ "n", "x", "o" }, "ä" .. ch, "]" .. ch, { remap = true, desc = "]" .. ch })
end

-- Visual indent (keep selection)
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Jump after paste
map("v", "y", "y`]", { silent = true, desc = "Yank and jump to end" })
map("v", "p", "p`]", { silent = true, desc = "Paste and jump to end" })
map("n", "p", "p`]", { silent = true, desc = "Paste and jump to end" })

-- Select pasted text
map("n", "gV", "`[v`]", { desc = "Select last pasted text" })

-- Upper/lower word
map("n", "<leader>uu", "mQviwU`Q", { desc = "Uppercase word" })
map("n", "<leader>ud", "mQviwu`Q", { desc = "Lowercase word" })

map("n", "<leader>p", "<cmd>e!<cr>", { desc = "Reload file" })

-- Underline
map("n", "<leader>ul", "<cmd>t.<CR>Vr=", { silent = true, desc = "Underline heading" })

-- Horizontal scroll
map("n", "zl", "zL", { desc = "Scroll half screen right" })
map("n", "zh", "zH", { desc = "Scroll half screen left" })

-- Escape
map("i", "jj", "<ESC>", { desc = "Escape" })

-- Blank lines
map("n", "<leader>dd", "m`:silent +g/\\m^\\s*$/d<CR>``:noh<CR>", { silent = true, desc = "Delete blank lines below" })
map("n", "<leader>dD", "m`:silent -g/\\m^\\s*$/d<CR>``:noh<CR>", { silent = true, desc = "Delete blank lines above" })

-- Folding
map("n", "zU", "zR", { desc = "Open all folds" })
map("n", "<leader>f", function()
  require("config.commands").toggle_folding()
end, { desc = "Toggle folding" })

-- Visual search
map(
  "x",
  "*",
  [[:<C-u>call v:lua.require('config.commands').visual_search('/')<CR>/<C-R>=@/<CR><CR>]],
  { desc = "Search selection forward" }
)
map(
  "x",
  "#",
  [[:<C-u>call v:lua.require('config.commands').visual_search('?')<CR>?<C-R>=@/<CR><CR>]],
  { desc = "Search selection backward" }
)

-- Quickfix / location list
map("n", "<leader>l", function()
  vim.diagnostic.setloclist({ open = false })
  require("config.commands").toggle_list("Location List", "l")
end, { silent = true, desc = "Toggle location list" })
map("n", "<leader>q", function()
  require("config.commands").toggle_list("Quickfix List", "c")
end, { silent = true, desc = "Toggle quickfix" })

-- Jump mappings
map("n", "]g", "]}", { desc = "Next unmatched }" })
map("n", "[g", "[{", { desc = "Previous unmatched {" })
map("n", "]h", "])", { desc = "Next unmatched )" })
map("n", "[h", "[(", { desc = "Previous unmatched (" })
-- remap so these follow the treesitter ]m/[m function motions
map("n", "öö", "[m", { remap = true, desc = "Previous function start" })
map("n", "ää", "]m", { remap = true, desc = "Next function start" })

-- Insert mode begin/end
map("i", "<C-A>", "<C-O>0", { desc = "Beginning of line" })
map("i", "<C-E>", "<C-O>$", { desc = "End of line" })

-- Register accessor
map("", ";", '"', { silent = true, desc = "Register accessor" })

-- Buffer switching
map("n", "Ä", "<cmd>bnext<cr>", { silent = true, desc = "Next buffer" })
map("n", "Ö", "<cmd>bprevious<cr>", { silent = true, desc = "Previous buffer" })
map("n", "'", "<cmd>bnext<cr>", { silent = true, desc = "Next buffer" })
map("n", '"', "<cmd>bprevious<cr>", { silent = true, desc = "Previous buffer" })

-- Breaking habits (disable arrows in insert/visual)
for _, key in ipairs({ "<Left>", "<Right>" }) do
  map("i", key, '<Esc><cmd>echo "Dude!"<cr>', { desc = "Disabled" })
end
for _, key in ipairs({ "<Left>", "<Right>", "<Up>", "<Down>" }) do
  map("v", key, '<Esc><cmd>echo "Dude!"<cr>', { desc = "Disabled" })
end

-- Disable backspace/space in normal
map("", "<backspace>", "<nop>", { desc = "Disabled" })
map("", "<space>", "<nop>", { desc = "Disabled" })

-- Exit
map("n", "<leader>a", "<cmd>qa<cr>", { desc = "Quit all" })
