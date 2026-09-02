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
map("n", "<C-c>", "<C-W>c", { desc = "Close window" })
map("n", "<C-n>", "<C-W>n", { desc = "New window" })
map("n", "<C-W>z", "<cmd>wincmd z<bar>cclose<bar>lclose<cr>", { desc = "Close preview/qf/loc" })
map("n", "<leader>v", "<C-w>v", { silent = true, desc = "Split vertical" })
map("n", "<leader>s", "<C-w>s", { silent = true, desc = "Split horizontal" })
map("n", "<leader>V", "<c-w>t<c-w>H", { silent = true, desc = "Layout vertical" })
map("n", "<leader>H", "<c-w>t<c-w>K", { silent = true, desc = "Layout horizontal" })

-- Window resizing (uses ResizeWindow from commands.lua)
map("n", "<Left>", function() require("config.commands").resize_window("h") end, { silent = true, desc = "Resize left" })
map("n", "<Right>", function() require("config.commands").resize_window("l") end, { silent = true, desc = "Resize right" })
map("n", "<Up>", function() require("config.commands").resize_window("k") end, { silent = true, desc = "Resize up" })
map("n", "<Down>", function() require("config.commands").resize_window("j") end, { silent = true, desc = "Resize down" })

-- Buffers
map("n", "<leader>bd", "<cmd>bd<cr>", { silent = true, desc = "Delete buffer" })
map("n", "<leader>bw", function() require("config.commands").wipeout(false) end, { silent = true, desc = "Wipeout buffer" })
map("n", "<leader>bo", function() require("config.commands").buf_only() end, { silent = true, desc = "Close other buffers" })
map("n", "<leader>bc", function() require("config.commands").buf_only(); vim.cmd("bd") end, { silent = true, desc = "Close all buffers" })

-- Fast save
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>W", "<cmd>Wall<cr>", { desc = "Save all" })
map("n", "<leader>S", "<cmd>SudoWrite<cr>", { desc = "Sudo save" })

-- Hex editor
map("n", "<leader>x", function() require("config.commands").toggle_hex() end, { desc = "Toggle hex" })

-- Settings toggles
map("n", "yoe", "<cmd>set expandtab!<bar>set expandtab?<cr>", { desc = "Toggle expandtab" })
map("n", "yom", "<cmd>Matches<cr>", { desc = "Show match count" })
map("n", "yot", function() require("config.commands").toggle_color_column() end, { desc = "Toggle color column" })
map("n", "<leader>h", "<cmd>nohlsearch<cr>", { silent = true, desc = "Clear search highlight" })

-- Command line
map("c", "<C-a>", "<Home>")
map("c", "<C-b>", "<Left>")
map("c", "<C-f>", "<Right>")
map("c", "<C-d>", "<Delete>")
map("c", "<M-b>", "<S-Left>")
map("c", "<M-f>", "<S-Right>")
map("c", "<M-d>", "<S-right><Delete>")
map("c", "<C-g>", "<C-c>")
map("c", "<C-p>", "<Up>")
map("c", "<C-n>", "<Down>")

-- Search
map("n", "&", "<cmd>&&<cr>")

-- German keyboard: ö → [, ä → ]
for c = 65, 90 do
  local ch = string.char(c)
  map({ "n", "x", "o" }, "ö" .. ch, "[" .. ch, { remap = true })
  map({ "n", "x", "o" }, "ä" .. ch, "]" .. ch, { remap = true })
end
for c = 97, 122 do
  local ch = string.char(c)
  map({ "n", "x", "o" }, "ö" .. ch, "[" .. ch, { remap = true })
  map({ "n", "x", "o" }, "ä" .. ch, "]" .. ch, { remap = true })
end

-- Visual indent (keep selection)
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Jump after paste
map("v", "y", "y`]", { silent = true })
map("v", "p", "p`]", { silent = true })
map("n", "p", "p`]", { silent = true })

-- Select pasted text
map("n", "gV", "`[v`]")

-- Upper/lower word
map("n", "<leader>uu", "mQviwU`Q")
map("n", "<leader>ud", "mQviwu`Q")

map("n", "<leader>p", "<cmd>e!<cr>", { desc = "Reload file" })

-- Underline
map("n", "<leader>ul", "<cmd>t.<CR>Vr=", { silent = true, desc = "Underline heading" })

-- Horizontal scroll
map("n", "zl", "zL")
map("n", "zh", "zH")

-- Escape
map("i", "jj", "<ESC>")

-- Blank lines
map("n", "<leader>dd", "m`:silent +g/\\m^\\s*$/d<CR>``:noh<CR>", { silent = true, desc = "Delete blank lines below" })
map("n", "<leader>dD", "m`:silent -g/\\m^\\s*$/d<CR>``:noh<CR>", { silent = true, desc = "Delete blank lines above" })
map("n", "<leader>o", "m`o<Esc>``", { silent = true, desc = "Blank line below" })
map("n", "<leader>O", "m`O<Esc>``", { silent = true, desc = "Blank line above" })

-- Folding
map("n", "zU", "zR")
map("n", "<leader>f", function() require("config.commands").toggle_folding() end, { desc = "Toggle folding" })

-- Visual search
map("x", "*", [[:<C-u>call v:lua.require('config.commands').visual_search('/')<CR>/<C-R>=@/<CR><CR>]])
map("x", "#", [[:<C-u>call v:lua.require('config.commands').visual_search('?')<CR>?<C-R>=@/<CR><CR>]])

-- Quickfix / location list
map("n", "<leader>l", function()
  vim.diagnostic.setloclist({ open = false })
  require("config.commands").toggle_list("Location List", "l")
end, { silent = true, desc = "Toggle location list" })
map("n", "<leader>q", function() require("config.commands").toggle_list("Quickfix List", "c") end, { silent = true, desc = "Toggle quickfix" })

-- Jump mappings
map("n", "]g", "]}")
map("n", "[g", "[{")
map("n", "]h", "])")
map("n", "[h", "[(")
map("n", "öö", "[m")
map("n", "ää", "]m")

-- Insert mode begin/end
map("i", "<C-A>", "<C-O>0")
map("i", "<C-E>", "<C-O>$")

-- Register accessor
map("", ";", '"', { silent = true })

-- Buffer switching
map("n", "Ä", "<cmd>bnext<cr>", { silent = true })
map("n", "Ö", "<cmd>bprevious<cr>", { silent = true })
map("n", "'", "<cmd>bnext<cr>", { silent = true })
map("n", '"', "<cmd>bprevious<cr>", { silent = true })

-- Breaking habits (disable arrows in insert/visual)
map("i", "<Left>", '<Esc><cmd>echo "Dude!"<cr>')
map("i", "<Right>", '<Esc><cmd>echo "Dude!"<cr>')
map("v", "<Left>", '<Esc><cmd>echo "Dude!"<cr>')
map("v", "<Right>", '<Esc><cmd>echo "Dude!"<cr>')
map("v", "<Up>", '<Esc><cmd>echo "Dude!"<cr>')
map("v", "<Down>", '<Esc><cmd>echo "Dude!"<cr>')

-- Disable backspace/space in normal
map("", "<backspace>", "<nop>")
map("", "<space>", "<nop>")

-- Exit
map("n", "<leader>a", "<cmd>qa<cr>", { desc = "Quit all" })

