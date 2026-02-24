local map = vim.keymap.set

-- Tabs
map("n", "<leader>n", "<cmd>tabnew<cr>")
map("n", "<leader>k", "<cmd>tabclose<cr>")
map("n", "<leader>to", "<cmd>tabonly<cr>")
map("n", "]v", "<cmd>tabnext<cr>")
map("n", "[v", "<cmd>tabprevious<cr>")
map("n", "]V", "<cmd>tablast<cr>")
map("n", "[V", "<cmd>tabfirst<cr>")

-- Windows
map("n", "<C-c>", "<C-W>c")
map("n", "<C-n>", "<C-W>n")
map("n", "<C-W>z", "<cmd>wincmd z<bar>cclose<bar>lclose<cr>")
map("n", "<leader>v", "<C-w>v", { silent = true })
map("n", "<leader>s", "<C-w>s", { silent = true })
map("n", "<leader>V", "<c-w>t<c-w>H", { silent = true })
map("n", "<leader>H", "<c-w>t<c-w>K", { silent = true })

-- Window resizing (uses ResizeWindow from commands.lua)
map("n", "<Left>", function() require("config.commands").resize_window("h") end, { silent = true })
map("n", "<Right>", function() require("config.commands").resize_window("l") end, { silent = true })
map("n", "<Up>", function() require("config.commands").resize_window("k") end, { silent = true })
map("n", "<Down>", function() require("config.commands").resize_window("j") end, { silent = true })

-- Buffers
map("n", "<leader>bd", "<cmd>bd<cr>", { silent = true })
map("n", "<leader>bw", function() require("config.commands").wipeout(false) end, { silent = true })
map("n", "<leader>bo", function() require("config.commands").buf_only() end, { silent = true })
map("n", "<leader>bc", function() require("config.commands").buf_only(); vim.cmd("bd") end, { silent = true })

-- Fast save
map("n", "<leader>w", "<cmd>w<cr>")
map("n", "<leader>W", "<cmd>W<cr>")
map("n", "<leader>S", "<cmd>SudoWrite<cr>")

-- Hex editor
map("n", "<leader>x", function() require("config.commands").toggle_hex() end)

-- Settings toggles
map("n", "yoe", "<cmd>set expandtab!<bar>set expandtab?<cr>")
map("n", "yom", "<cmd>Matches<cr>")
map("n", "yot", function() require("config.commands").toggle_color_column() end)
map("n", "<leader>h", "<cmd>nohlsearch<cr>", { silent = true })

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

-- Yank and search
map("n", "Y", "y$")
map("n", "&", "<cmd>&&<cr>")

-- German keyboard: ö → [, ä → ]
for c = 65, 90 do
  local ch = string.char(c)
  map({ "n", "x" }, "ö" .. ch, "[" .. ch, { remap = true })
  map({ "n", "x" }, "ä" .. ch, "]" .. ch, { remap = true })
end
for c = 97, 122 do
  local ch = string.char(c)
  map({ "n", "x" }, "ö" .. ch, "[" .. ch, { remap = true })
  map({ "n", "x" }, "ä" .. ch, "]" .. ch, { remap = true })
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

-- Replay last macro
map("n", "Q", "@@")

-- Upper/lower word
map("n", "<leader>uu", "mQviwU`Q")
map("n", "<leader>ud", "mQviwu`Q")

map("n", "<leader>p", "<cmd>e!<cr>")

-- Underline
map("n", "<leader>ul", "<cmd>t.<CR>Vr=", { silent = true })

-- Horizontal scroll
map("n", "zl", "zL")
map("n", "zh", "zH")

-- Escape
map("i", "jj", "<ESC>")

-- Blank lines
map("n", "<leader>d", "m`:silent +g/\\m^\\s*$/d<CR>``:noh<CR>", { silent = true })
map("n", "<leader>D", "m`:silent -g/\\m^\\s*$/d<CR>``:noh<CR>", { silent = true })
map("n", "<leader>o", "<cmd>set paste<CR>m`o<Esc>``:set nopaste<CR>", { silent = true })
map("n", "<leader>O", "<cmd>set paste<CR>m`O<Esc>``:set nopaste<CR>", { silent = true })

-- Folding
map("n", "zU", "zR")
map("n", "<leader>f", function() require("config.commands").toggle_folding() end)

-- Visual search
map("x", "*", [[:<C-u>call v:lua.require('config.commands').visual_search('/')<CR>/<C-R>=@/<CR><CR>]])
map("x", "#", [[:<C-u>call v:lua.require('config.commands').visual_search('?')<CR>?<C-R>=@/<CR><CR>]])

-- Quickfix / location list
map("n", "<leader>l", function()
  vim.diagnostic.setloclist({ open = false })
  require("config.commands").toggle_list("Location List", "l")
end, { silent = true })
map("n", "<leader>q", function() require("config.commands").toggle_list("Quickfix List", "c") end, { silent = true })

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
map("i", "<Left>", '<Esc><cmd>echoe "Dude!"<cr>')
map("i", "<Right>", '<Esc><cmd>echoe "Dude!"<cr>')
map("v", "<Left>", '<Esc><cmd>echoe "Dude!"<cr>')
map("v", "<Right>", '<Esc><cmd>echoe "Dude!"<cr>')
map("v", "<Up>", '<Esc><cmd>echoe "Dude!"<cr>')
map("v", "<Down>", '<Esc><cmd>echoe "Dude!"<cr>')

-- Disable backspace/space in normal
map("", "<backspace>", "<nop>")
map("", "<space>", "<nop>")

-- Exit
map("n", "<leader>a", "<cmd>qa<cr>")

