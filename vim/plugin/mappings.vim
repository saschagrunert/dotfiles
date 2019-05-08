" fast tab switching
nnoremap <leader>n :tabnew<cr>
nnoremap <leader>k :tabclose<cr>
nnoremap <leader>to :tabonly<cr>
nnoremap ]v :tabnext<cr>
nnoremap [v :tabprevious<cr>
nnoremap ]V :tablast<cr>
nnoremap [V :tabfirst<cr>

" fast window switching and resizing
nnoremap <C-c> <C-W>c
nnoremap <C-n> <C-W>n
nnoremap <silent><Left> :call ResizeWindow('h')<cr>
nnoremap <silent><Right> :call ResizeWindow('l')<cr>
nnoremap <silent><Up> :call ResizeWindow('k')<cr>
nnoremap <silent><Down> :call ResizeWindow('j')<cr>
nnoremap <silent><leader>V <c-w>t<c-w>H
nnoremap <silent><leader>H <c-w>t<c-w>K

" close preview, quickfix and location list
nnoremap <C-W>z :wincmd z<bar>cclose<bar>lclose<cr>

" fast windows splitting
nnoremap <silent> <leader>v <C-w>v
nnoremap <silent> <leader>s <C-w>s

" fast buffer switching
nnoremap <silent> <leader>bd :bd<cr>
nnoremap <silent> <leader>bw :Wipeout<cr>
nnoremap <silent> <leader>bo :BufOnly!<cr>
nnoremap <silent> <leader>bc :BufOnly!<cr>:bd<cr>

" 'info panel' mappings
nnoremap <silent> cmt :TagbarToggle<CR>
nnoremap <silent> cmu :UndotreeToggle<CR>

" fast save
nnoremap <leader>w :w<cr>
nnoremap <leader>W :W<cr>
nnoremap <leader>S :SudoWrite<cr>

" hex editor
nnoremap <leader>x :Hexmode<cr>

" 'set' and 'show'  mappings
nnoremap yoe :set expandtab!<bar>set expandtab?<cr>
nnoremap yom :Matches<cr>
nnoremap yot :call ToggleColorColumn()<CR>
nnoremap <silent><leader>h :nohlsearch<cr>

" better command line
cnoremap <C-a>  <Home>
cnoremap <C-b>  <Left>
cnoremap <C-f>  <Right>
cnoremap <C-d>  <Delete>
cnoremap <M-b>  <S-Left>
cnoremap <M-f>  <S-Right>
cnoremap <M-d>  <S-right><Delete>
cnoremap <Esc>b <S-Left>
cnoremap <Esc>f <S-Right>
cnoremap <Esc>d <S-right><Delete>
cnoremap <C-g>  <C-c>

" better yank and search and replace
nnoremap Y y$
nnoremap & :&&<cr>

" better prev next in command line mode
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" change [ and ] to ö and ä
for s:c in map(range(65,90) + range(97,122),'nr2char(v:val)')
    exec 'nmap ö'.s:c.' ['.s:c
    exec 'xmap ö'.s:c.' ['.s:c
    exec 'nmap ä'.s:c.' ]'.s:c
    exec 'xmap ä'.s:c.' ]'.s:c
endfor

" reselect visual selection after indent
vnoremap < <gv
vnoremap > >gv

" jump directly to the pos after the paste
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" slect pasted text
noremap gV `[v`]`

" map Q to play last macro
nnoremap Q @@

" upper/lower whole word
nnoremap <leader>uu mQviwU`Q
nnoremap <leader>ud mQviwu`Q

" some edit more helpers
nnoremap <leader>ew :e <C-R>=expand('%:h').'/'<cr>
nnoremap <leader>es :sp <C-R>=expand('%:h').'/'<cr>
nnoremap <leader>ev :vsp <C-R>=expand('%:h').'/'<cr>
nnoremap <leader>et :tabe <C-R>=expand('%:h').'/'<cr>
nnoremap <leader>p :e!<cr>

" Underline the current line with '='
nnoremap <silent> <leader>ul :t.<CR>Vr=

" easier horizontal scrolling
nnoremap zl zL
nnoremap zh zH

" the escape button is too far away
inoremap jj <ESC>

" insert/delete blank lines
nnoremap <silent><leader>d m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><leader>D m`:silent -g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><leader>o :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><leader>O :set paste<CR>m`O<Esc>``:set nopaste<CR>

" my personal unfold mapping
nnoremap zU zR

" reselect pasted text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]''`]`'

" Search in range
vnoremap <silent> / :<C-U>call RangeSearch('/')<CR>:if strlen(g:srchstr)
                    \ > 0\|exec '/'.g:srchstr\|endif<CR>
vnoremap <silent> ? :<C-U>call RangeSearch('?')<CR>:if strlen(g:srchstr)
                    \ > 0\|exec '?'.g:srchstr\|endif<CR>

" run commands
let ft_stdout_mappings = {
            \'applescript'  : 'osascript',
            \'bash'         : 'bash',
            \'bc'           : 'bc',
            \'javascript'   : 'node',
            \'nodejs'       : 'node',
            \'perl'         : 'perl',
            \'php'          : 'php',
            \'python'       : 'python',
            \'ruby'         : 'ruby',
            \'sh'           : 'sh',
            \'tex'          : 'pdflatex'
            \}
let ft_execute_mappings = {
            \'c'            : 'gcc -o %:r -Wall -std=c99 % && ./%:r'
            \}
let ft_command_mappings = {
            \'rust'         : 'RustRun'
            \}
for ft_name in keys(ft_stdout_mappings)
    execute 'autocmd Filetype ' . ft_name
            \. ' nnoremap <silent><buffer><leader>r :write !'
            \. ft_stdout_mappings[ft_name] . '<CR>'
endfor
for ft_name in keys(ft_execute_mappings)
    execute 'autocmd FileType ' . ft_name
            \. ' nnoremap <silent><buffer><leader>r :write \| !'
            \. ft_execute_mappings[ft_name] . '<CR>'
endfor
for ft_name in keys(ft_command_mappings)
    execute 'autocmd FileType ' . ft_name
            \. ' nnoremap <silent><buffer><leader>r :write \| :'
            \. ft_command_mappings[ft_name] . '<CR>'
endfor

" exit
nnoremap <leader>a :qa<cr>

" makes # and * also work in visual mode
xnoremap * :<C-u>call VisualSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call VisualSearch('?')<CR>?<C-R>=@/<CR><CR>

" toggle quickfix and location list
nnoremap <silent> <leader>l :call ToggleList("Location List", 'l')<CR>
nnoremap <silent> <leader>q :call ToggleList("Quickfix List", 'c')<CR>

" better jump mappings
nnoremap ]g ]}
nnoremap [g [{
nnoremap ]h ])
nnoremap [h [(
nnoremap öö [m
nnoremap ää ]m

" insert mode begin/end of line
inoremap <C-A> <C-O>0
inoremap <C-E> <C-O>$

" remap the register accessor
nnoremap <silent> ; "

" fast buffer switching
nnoremap <silent> Ä :bnext<cr>
nnoremap <silent> Ö :bprevious<cr>
nnoremap <silent> ' :bnext<cr>
nnoremap <silent> " :bprevious<cr>

" breaking the habits
inoremap <Left> <Esc>:echoe "Dude!"<cr>
inoremap <Right> <Esc>:echoe "Dude!"<cr>
vnoremap <Left> <Esc>:echoe "Dude!"<cr>
vnoremap <Right> <Esc>:echoe "Dude!"<cr>
vnoremap <Up> <Esc>:echoe "Dude!"<cr>
vnoremap <Down> <Esc>:echoe "Dude!"<cr>

" folding
map <leader>f :call ToggleFolding()<CR>

" no hacks
noremap <backspace> <nop>
noremap <space> <nop>
