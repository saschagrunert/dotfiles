if exists('g:loaded_ctrlp_marks') && g:loaded_ctrlp_marks
    finish
endif
let g:loaded_ctrlp_marks = 1

let s:marks_var = {
    \  'init':   'ctrlp#marks#init()',
    \  'exit':   'ctrlp#marks#exit()',
    \  'accept': 'ctrlp#marks#accept',
    \  'lname':  'marks',
    \  'sname':  'marks',
    \  'type':   'marks',
    \  'sort':   0,
    \}

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
    let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:marks_var)
else
    let g:ctrlp_ext_vars = [s:marks_var]
endif

function! ctrlp#marks#init()
    let s = ''
    redir => s
    silent marks
    redir END
    return split(s, "\n")[1:]
endfunc

function! ctrlp#marks#accept(mode, str)
    call ctrlp#exit()
    exe "normal! g'".matchstr(a:str, '^\s*\zs\S\+\ze\s.*')
endfunction

function! ctrlp#marks#exit()
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#marks#id()
    return s:id
endfunction
