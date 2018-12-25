if exists('g:loaded_ctrlp_git_mergefiles') && g:loaded_ctrlp_git_mergefiles
    finish
endif
let g:loaded_ctrlp_git_mergefiles = 1

let s:git_mergefiles_var = {
            \ 'init':   'ctrlp#git_mergefiles#init()',
            \ 'accept': 'ctrlp#git_mergefiles#accept',
            \ 'lname':  'Git merge files',
            \ 'sname':  'Git merge files',
            \ 'type':   'line',
            \ 'enter':  'ctrlp#git_mergefiles#enter()',
            \ 'exit':   'ctrlp#git_mergefiles#exit()',
            \ 'sort':   0,
            \ }

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
    let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:git_mergefiles_var)
else
    let g:ctrlp_ext_vars = [s:git_mergefiles_var]
endif

function! ctrlp#git_mergefiles#init()
    call s:syntax()
    return s:files
endfunc

function! ctrlp#git_mergefiles#accept(mode, str)
    call ctrlp#exit()
    let selectedFile = split(a:str, '\t')[-1]
    silent exe ":e ".selectedFile
endfunction

fu! s:syntax()
    if !ctrlp#nosy()
        cal ctrlp#hicheck('CtrlPGitMergeFile', 'Keyword')
        cal ctrlp#hicheck('CtrlPGitMergeFileName', 'CursorLineNr')
        syn match CtrlPGitMergeFile '\s\(M\|C\|R\|A\|D\|U\)\s'
        syn match CtrlPGitMergeFileName '\v[^/]*$'
    endif
endfunction

" Do something before enterting ctrlp
function! ctrlp#git_mergefiles#enter()
    let s:files = split(system('git diff --name-status $(git merge-base master $(git rev-parse --abbrev-ref HEAD)) HEAD'), "\n")
endfunction

" Do something after exiting ctrlp
function! ctrlp#git_mergefiles#exit()
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#git_mergefiles#id()
    return s:id
endfunction

