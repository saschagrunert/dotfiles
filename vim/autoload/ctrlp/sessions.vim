if exists('g:loaded_ctrlp_sessions') && g:loaded_ctrlp_sessions
    finish
endif
let g:loaded_ctrlp_sessions = 1

let s:sessions_var = {
    \  'init':   'ctrlp#sessions#init()',
    \  'exit':   'ctrlp#sessions#exit()',
    \  'accept': 'ctrlp#sessions#accept',
    \  'lname':  'sessions',
    \  'sname':  'sessions',
    \  'type':   'sessions',
    \  'sort':   0,
    \}

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
    let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:sessions_var)
else
    let g:ctrlp_ext_vars = [s:sessions_var]
endif

function! ctrlp#sessions#init()
    return split(system('ls '.g:startify_session_dir.'| ag -v ".lock|__LAST__" | sed "s/.vim//g"'), '\n')
endfunc

function! ctrlp#sessions#accept(mode, str)
    call ctrlp#exit()
    exe "OpenSession! ".a:str
endfunction

function! ctrlp#sessions#exit()
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#sessions#id()
    return s:id
endfunction
