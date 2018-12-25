" search in the current selected range
function! RangeSearch(direction)
    call inputsave()
    let g:srchstr = input(a:direction)
    call inputrestore()
    if strlen(g:srchstr) > 0
        let g:srchstr = g:srchstr.
                    \ '\%>'.(line("'<")-1).'l'.
                    \ '\%<'.(line("'>")+1).'l'
    else
        let g:srchstr = ''
    endif
endfunction

" delete all not visible buffers
function! Wipeout(bang)
    let visible = {}
    for t in range(1, tabpagenr('$'))
        for b in tabpagebuflist(t)
            let visible[b] = 1
        endfor
    endfor
    let l:tally = 0
    let l:cmd = 'bw'
    if a:bang
        let l:cmd .= '!'
    endif
    for b in range(1, bufnr('$'))
        if buflisted(b) && !has_key(visible, b)
            let l:tally += 1
            exe l:cmd . ' ' . b
        endif
    endfor
    echon "Deleted " . l:tally . " buffers"
endfunction

" execute with Qargs to every quickfix item
function! QuickfixFilenames()
    " Building a hash ensures we get each buffer only once
    let buffer_numbers = {}
    for quickfix_item in getqflist()
        let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
    endfor
    return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction

" toggle current buffer to hex and reverse
function ToggleHex()
    let l:modified=&mod
    let l:oldreadonly=&readonly
    let &readonly=0
    let l:oldmodifiable=&modifiable
    let &modifiable=1
    if !exists("b:editHex") || !b:editHex
        let b:oldft=&ft
        let b:oldbin=&bin
        setlocal binary
        let &ft="xxd"
        let b:editHex=1
        %!xxd -g 1
    else
        let &ft=b:oldft
        if !b:oldbin
            setlocal nobinary
        endif
        let b:editHex=0
        %!xxd -r
    endif
    let &mod=l:modified
    let &readonly=l:oldreadonly
    let &modifiable=l:oldmodifiable
endfunction

" toggle the colorcolumn
function! ToggleColorColumn()
    if &colorcolumn != ''
        setlocal colorcolumn&
    else
        setlocal colorcolumn=80
    endif
endfunction

" makes * and # work on visual mode too.
function! VisualSearch(cmdtype)
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
    let @s = temp
endfunction

" remove all other buffers
function! BufOnly(buffer, bang)
    if a:buffer == ''
        let buffer = bufnr('%')
    elseif (a:buffer + 0) > 0
        let buffer = bufnr(a:buffer + 0)
    else
        let buffer = bufnr(a:buffer)
    endif
    if buffer == -1
        echohl ErrorMsg
        echomsg "No matching buffer for" a:buffer
        echohl None
        return
    endif
    let last_buffer = bufnr('$')
    let delete_count = 0
    let n = 1
    while n <= last_buffer
        if n != buffer && buflisted(n)
            if a:bang == '' && getbufvar(n, '&modified')
                echohl ErrorMsg
                echomsg 'No write since last change for buffer'
                            \ n '(add ! to override)'
                echohl None
            else
                silent exe 'bdel' . a:bang . ' ' . n
                if ! buflisted(n)
                    let delete_count = delete_count+1
                endif
            endif
        endif
        let n = n+1
    endwhile
    if delete_count == 1
        echomsg delete_count "buffer deleted"
    elseif delete_count > 1
        echomsg delete_count "buffers deleted"
    endif
endfunction

function! GetBufferList()
    redir =>buflist
    silent! ls
    redir END
    return buflist
endfunction

function! ToggleList(bufname, pfx)
    let buflist = GetBufferList()
    for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
        if bufwinnr(bufnum) != -1
            exec(a:pfx.'close')
            return
        endif
    endfor
    exec(a:pfx.'open')
endfunction

" Whenever or not there is a window on the provided side.
function! HasWindow(side)
    let _eventignore = &eventignore
    set eventignore=all
    let result = 0
    let crr_win = winnr()
    exe '5wincmd ' . a:side
    if winnr() != crr_win
        let result = 1
        exe crr_win . 'wincmd w'
    endif
    let &eventignore = _eventignore
    return result
endfunction

function! ResizeWindow(dir)
    let crr_win = winnr()
    if a:dir == 'h'
        if HasWindow('h') && !HasWindow('l')
            5wincmd >
        elseif HasWindow('h') && HasWindow('l')
            5wincmd l
            5wincmd >
            exe crr_win . '5wincmd w'
        elseif HasWindow('l') && !HasWindow('h')
            5wincmd <
        endif
    elseif a:dir == 'l'
        if HasWindow('l') && !HasWindow('h')
            5wincmd >
        elseif HasWindow('l') && HasWindow('h')
            5wincmd l
            5wincmd <
            exe crr_win . '5wincmd w'
        elseif HasWindow('h') && !HasWindow('l')
            5wincmd <
        endif
    elseif a:dir == 'k'
        if HasWindow('j') && !HasWindow('k')
            5wincmd -
        elseif HasWindow('j') && HasWindow('k')
            5wincmd j
            5wincmd +
            exe crr_win . '5wincmd w'
        elseif HasWindow('k')
            5wincmd +
        elseif HasWindow('j')
            5wincmd j
            5wincmd +
            exe crr_win . '5wincmd w'
        endif
    elseif a:dir == 'j'
        if HasWindow('j')
            5wincmd +
        elseif HasWindow('k')
            5wincmd k
            5wincmd +
            exe crr_win . '5wincmd w'
        endif
    endif
endfunction

" multiple git diffs in tabs
function! TabMultiDiff()
    let s:tab_multi_diff = 0
    argdo call s:AddBufferToTab()
    tabclose
endfun

function! TabMultiDiffMaximized()
    augroup TabMultiDiffMaximize
        autocmd VimResized * silent! call EquilizeAllTabWindows()
    augroup END
    set lines=999 columns=999
    call TabMultiDiff()
endfun

function! EquilizeAllTabWindows()
    let orig = tabpagenr()
    tabdo wincmd =
    while tabpagenr() != orig
        tabprevious
    endwhile
endfun

function! s:AddBufferToTab()
    let buf = bufnr("%")
    if s:tab_multi_diff
        tablast
        vsplit
        wincmd w
    else
        tab split
        tabmove
    endif
    let s:tab_multi_diff = ! s:tab_multi_diff
    exe 'b ' . buf
    diffthis
    tabfirst
endfun

" toggle syntax based folding
function! ToggleFolding()
    if (!exists("b:outline_mode"))
        let b:outline_mode = 0
    endif
    if (b:outline_mode == 0)
        echo "Enabling syntax based folding."
        set foldmethod=syntax
        set foldenable
        let b:outline_mode = 1
    else
        echo "Disabling syntax based folding."
        set foldmethod=manual
        set nofoldenable
        let b:outline_mode = 0
    endif
endfunction
