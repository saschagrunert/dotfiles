let g:incsearch#auto_nohlsearch = 1
let g:incsearch#consistent_n_direction = 1
let g:incsearch#magic = '\v'
let g:incsearch#separate_highlight = 1

map #  <Plug>(incsearch-nohl-#)
map *  <Plug>(incsearch-nohl-*)
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map N  <Plug>(incsearch-nohl-N)
map g# <Plug>(incsearch-nohl-g#)
map g* <Plug>(incsearch-nohl-g*)
map g/ <Plug>(incsearch-stay)
map n  <Plug>(incsearch-nohl-n)
