if exists('g:loaded_ctrlp_git_branch') && g:loaded_ctrlp_git_branch
    finish
endif
let g:loaded_ctrlp_git_branch = 1

let s:git_branch_var = {
            \ 'init':   'ctrlp#git_branch#init()',
            \ 'accept': 'ctrlp#git_branch#accept',
            \ 'lname':  'Git branch',
            \ 'sname':  'Git branch',
            \ 'type':   'line',
            \ 'enter':  'ctrlp#git_branch#enter()',
            \ 'exit':   'ctrlp#git_branch#exit()',
            \ 'sort':   1,
            \ }

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
    let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:git_branch_var)
else
    let g:ctrlp_ext_vars = [s:git_branch_var]
endif

function! ctrlp#git_branch#init()
    return s:files
endfunc

function! ctrlp#git_branch#accept(mode, str)
    call ctrlp#exit()
    call system('git checkout ' . a:str)
    echo "Checked out branch ".a:str
endfunction

" Do something before enterting ctrlp
function! ctrlp#git_branch#enter()
    let s:files = split(system('git branch -r | ag -v "\-\>" | sed "s/.*origin\///g"'), "\n")
endfunction

" Do something after exiting ctrlp
function! ctrlp#git_branch#exit()
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#git_branch#id()
    return s:id
endfunction

