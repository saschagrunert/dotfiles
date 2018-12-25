let g:ctrlp_use_caching = 0
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_mruf_max = 250
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_by_filename = 1
let g:ctrlp_match_window = 'top,order:ttb,min:1,max:15,results:15'
let g:ctrlp_open_multiple_files = '1vjr'
let g:ctrlp_user_command = [
    \ '.git',
    \ 'cd %s && git ls-files . -co --exclude-standard ":!:vendor"',
    \ 'rg %s -l --color never -S -g ""'
    \ ]

command! CtrlPGitLog call ctrlp#init(ctrlp#git_log#id())
command! CtrlPGitMergeFiles call ctrlp#init(ctrlp#git_mergefiles#id())
command! CtrlPGitBranch call ctrlp#init(ctrlp#git_branch#id())
command! CtrlPRegister call ctrlp#init(ctrlp#register#id())
command! CtrlPMarks call ctrlp#init(ctrlp#marks#id())
command! CtrlPLocList call ctrlp#init(ctrlp#loclist#id())

nnoremap <silent> <S-TAB> :CtrlPBufTagAll<CR>
nnoremap <silent> cpa :CtrlPBookmarkDirAdd<CR>
nnoremap <silent> cpb :CtrlPGitBranch<CR>
nnoremap <silent> cpc :CtrlPTag<CR>
nnoremap <silent> cpd :CtrlPBookmarkDir<CR>
nnoremap <silent> cpf :CtrlPGitMergeFiles<CR>
nnoremap <silent> cpg :CtrlPGitLog<CR>
nnoremap <silent> cpi :CtrlPLine<CR>
nnoremap <silent> cpk :CtrlPMarks<CR>
nnoremap <silent> cpl :CtrlPLocList<CR>
nnoremap <silent> cpm :CtrlPMRUFiles<CR>
nnoremap <silent> cpp :CtrlPBuffer<CR>
nnoremap <silent> cpq :CtrlPQuickfix<CR>
nnoremap <silent> cpr :CtrlPRegister<CR>
nnoremap <silent> cpt :CtrlPBufTagAll<CR>
nnoremap <silent> cpu :CtrlPChange<CR>
