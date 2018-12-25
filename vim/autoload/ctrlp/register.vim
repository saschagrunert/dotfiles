if exists('g:loaded_ctrlp_register') && g:loaded_ctrlp_register
    finish
endif
let g:loaded_ctrlp_register = 1

let s:register_var = {
    \  'init':   'ctrlp#register#init()',
    \  'exit':   'ctrlp#register#exit()',
    \  'accept': 'ctrlp#register#accept',
    \  'lname':  'register',
    \  'sname':  'register',
    \  'type':   'register',
    \  'sort':   0,
    \}

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
    let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:register_var)
else
    let g:ctrlp_ext_vars = [s:register_var]
endif

function! ctrlp#register#init()
    let s = ''
    redir => s
    silent registers
    redir END
    return split(s, "\n")[1:]
endfunc

function! ctrlp#register#accept(mode, str)
    call ctrlp#exit()
    exe "normal! ".matchstr(a:str, '^\S\+\ze.*')."p"
endfunction

function! ctrlp#register#exit()
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#register#id()
    return s:id
endfunction

