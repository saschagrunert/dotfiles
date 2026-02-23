nnoremap <leader>gs :Git<cr>
nnoremap <leader>gd :Gdiffsplit<cr>
nnoremap <leader>gc :Gwrite<bar>w<bar>Git commit<cr>A
nnoremap <leader>gb :Git blame<cr>
nnoremap <leader>gl :Git pull<cr>
nnoremap <leader>gw :Gwrite<cr>
nnoremap <leader>gr :Gread<cr>
nnoremap <leader>ge :Gedit<cr>
nnoremap <leader>gp :w<bar>Git push<cr>
nnoremap <leader>gf :Git fetch<cr>
nnoremap <leader>go :Git pull --rebase<cr>

command -bar -bang -nargs=* Gshow :Git!<bang> show <args>
command -bar -bang -nargs=* Gparse :Git<bang> rev-parse <args>
command Gmergebase :!git merge-base origin/HEAD $(git rev-parse --abbrev-ref HEAD)

au FileType gitcommit inoremap <buffer>jj <ESC>ZZ
