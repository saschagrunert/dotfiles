-- Additional date formats for vim-speeddating
if vim.fn.exists(":SpeedDatingFormat") == 0 then
  return
end

vim.cmd("SpeedDatingFormat %d.%m.%y")
vim.cmd("SpeedDatingFormat %d.%m.%Y")
vim.cmd("SpeedDatingFormat %d/%m/%y")
vim.cmd("SpeedDatingFormat %d/%m/%Y")
vim.cmd("SpeedDatingFormat %d-%m-%y")
vim.cmd("SpeedDatingFormat %d-%m-%Y")
