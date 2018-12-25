let g:EasyMotion_smartcase = 1
let g:EasyMotion_enter_jump_first = 1
let g:EasyMotion_space_jump_first = 1
let g:EasyMotion_move_highlight = 0
let g:EasyMotion_startofline = 0

nmap s <Plug>(easymotion-overwin-f2)
xmap s <Plug>(easymotion-s2)
omap z <Plug>(easymotion-s2)

nmap <leader><leader>S <Plug>(easymotion-jumptoanywhere)
xmap <leader><leader>S <Plug>(easymotion-jumptoanywhere)
omap <leader><leader>S <Plug>(easymotion-jumptoanywhere)

nmap S <Plug>(easymotion-sn)
xmap Z <Plug>(easymotion-sn)
omap Z <Plug>(easymotion-sn)

nmap f <Plug>(easymotion-fl)
nmap F <Plug>(easymotion-Fl)
xmap f <Plug>(easymotion-fl)
xmap F <Plug>(easymotion-Fl)
omap f <Plug>(easymotion-fl)
omap F <Plug>(easymotion-Fl)

xmap t <Plug>(easymotion-tl)
xmap T <Plug>(easymotion-Tl)
omap t <Plug>(easymotion-tl)
omap T <Plug>(easymotion-Tl)

nmap , <Plug>(easymotion-next)
nmap ; <Plug>(easymotion-prev)

nmap j <Plug>(easymotion-j)
nmap k <Plug>(easymotion-k)
nmap l <Plug>(easymotion-lineforward)
nmap h <Plug>(easymotion-linebackward)

vmap <leader>j <Plug>(easymotion-j)
vmap <leader>k <Plug>(easymotion-k)
vmap <leader>h <Plug>(easymotion-linebackward)
vmap <leader>l <Plug>(easymotion-lineforward)

map <leader><leader>J <Plug>(easymotion-eol-j)
map <leader><leader>K <Plug>(easymotion-eol-k)
