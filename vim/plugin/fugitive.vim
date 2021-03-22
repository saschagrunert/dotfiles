nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gd :Gdiff<cr>
nnoremap <leader>gc :Gwrite<bar>w<bar>Gcommit<cr>A
nnoremap <leader>gb :Git blame<cr>
nnoremap <leader>gl :Gpull<cr>
nnoremap <leader>gw :Gwrite<cr>
nnoremap <leader>gr :Gread<cr>
nnoremap <leader>ge :Gedit<cr>
nnoremap <leader>gp :w<bar>Gpush<cr>
nnoremap <leader>gf :Gfetch<cr>
nnoremap <leader>go :Gpull --rebase<cr>

command -bar -bang -nargs=* Gshow :Git!<bang> show <args>
command -bar -bang -nargs=* Gparse :Git<bang> rev-parse <args>
command Gmergebase :!git merge-base origin/master $(git rev-parse --abbrev-ref HEAD)

au FileType gitcommit inoremap <buffer>jj <ESC>ZZ
