" file type settings
autocmd FileType typescript,ruby,rdoc,cucumber,haskell,yaml setlocal softtabstop=2 tabstop=2 shiftwidth=2
autocmd Filetype plaintex,text,markdown,tex setlocal textwidth=80

" Return to last edit position when opening files
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" automatically adjust the quick fix height
au FileType qf call AdjustWindowHeight(1, 10)
function! AdjustWindowHeight(minheight, maxheight)
    let l = 1
    let n_lines = 0
    let w_width = winwidth(0)
    while l <= line('$')
        let l_len = strlen(getline(l)) + 0.0
        let line_width = l_len/w_width
        let n_lines += float2nr(ceil(line_width))
        let l += 1
    endw
    exe max([min([n_lines, a:maxheight]), a:minheight]) . "wincmd _"
endfunction

" automatically adjust the preview window height
au BufEnter ?* call PreviewHeightWorkAround()
function! PreviewHeightWorkAround()
    if &previewwindow
        call AdjustWindowHeight(1,20)
    endif
endfunction

" markdown fun
au BufNewFile,BufReadPost *.md set filetype=markdown
let g:markdown_fenced_languages = [ 'css', 'erb=eruby', 'javascript', 'js=javascript', 'json=javascript', 'ruby', 'sass', 'xml', 'html' ]

" no wrap for qf windows
autocmd FileType qf setlocal nowrap
