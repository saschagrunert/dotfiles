if exists('g:loaded_ctrlp_git_log') && g:loaded_ctrlp_git_log
    finish
endif
let g:loaded_ctrlp_git_log = 1

let s:git_log_var = {
            \ 'init':   'ctrlp#git_log#init()',
            \ 'accept': 'ctrlp#git_log#accept',
            \ 'lname':  'Git log',
            \ 'sname':  'Git log',
            \ 'type':   'line',
            \ 'enter':  'ctrlp#git_log#enter()',
            \ 'exit':   'ctrlp#git_log#exit()',
            \ 'sort':   0,
            \ }

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
    let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:git_log_var)
else
    let g:ctrlp_ext_vars = [s:git_log_var]
endif

function! ctrlp#git_log#init()
    call s:syntax()
    return s:log
endfunc

function! ctrlp#git_log#accept(mode, str)
    call ctrlp#exit()
    let hash = substitute(a:str, "^\\(.\\+\\)\\s|.*$", "\\1", "")
    silent exe ":tabnew ".hash
    silent exe ":%r!git show ".hash
    0d
    setlocal syntax=git buftype=nofile bufhidden=wipe
                \ nobuflisted noswapfile
                \ nowrap readonly
endfunction

fu! s:syntax()
    if !ctrlp#nosy()
        cal ctrlp#hicheck('CtrlPGitLogHash', 'Keyword')
        cal ctrlp#hicheck('CtrlPGitLogUserTime', 'CursorLineNr')
        syn match CtrlPGitLogHash '\x\{40}'
        syn match CtrlPGitLogUserTime '|\ \zs.\{-}\ze\ -'
    endif
endfunction

" Do something before enterting ctrlp
function! ctrlp#git_log#enter()
    let s:log = split(system('git log -n 500 --pretty=format:"%H | %cr, %an - %s"'), "\n")
endfunction

" Do something after exiting ctrlp
function! ctrlp#git_log#exit()
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#git_log#id()
    return s:id
endfunction

