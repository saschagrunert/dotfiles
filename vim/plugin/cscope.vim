if has('cscope')
    set cscopetagorder=0
    set cscopetag
    set cscopeverbose
    set cscopequickfix=s-,c-,d-,i-,t-,e-
    set cscopepathcomp=3

    function! LoadCscope()
        let db = findfile("cscope.out", ".;")
        if (!empty(db))
            let path = strpart(db, 0, match(db, "/cscope.out$"))
            set nocscopeverbose " suppress 'duplicate connection' error
            exe "cs add " . db . " " . path
            set cscopeverbose
        endif
    endfunction
    au BufEnter /* call LoadCscope()

    nnoremap T :cs find c <C-R>=expand("<cword>")<CR><CR>
    nnoremap t <C-]>
    nnoremap gt <C-W><C-]>
    nnoremap gT <C-W><C-]><C-W>T
    nnoremap <leader>z :Dispatch echo "Generating tags and cscope database..." &&
                        \ ctags -R --fields=+aimSl --c-kinds=+lpx --c++-kinds=+lpx --exclude=.svn 
                        \ --exclude=.git --exclude=*.a --exclude=*.so && find . -iname '*.c' -o 
                        \ -iname '*.cpp' -o -iname '*.h' -o -iname '*.hpp' 
                        \ > cscope.files && cscope -b -i cscope.files -f cscope.out &&
                        \ echo "Done." <CR><CR>

    cnoreabbrev csa cs add
    cnoreabbrev csf cs find
    cnoreabbrev csk cs kill
    cnoreabbrev csr cs reset
    cnoreabbrev css cs show
    cnoreabbrev csh cs help
    cnoreabbrev csc Cscope
    command! Cscope :call LoadCscope()
endif
