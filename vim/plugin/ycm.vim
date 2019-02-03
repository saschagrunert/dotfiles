let g:ycm_add_preview_to_completeopt = 0
let g:ycm_allow_changing_updatetime = 0
let g:ycm_always_populate_location_list = 1
let g:ycm_autoclose_preview_window_after_insertion = 0
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_complete_in_comments = 1
let g:ycm_complete_in_strings = 1
let g:ycm_confirm_extra_conf = 0
let g:ycm_disable_for_files_larger_than_kb = 5000
let g:ycm_enable_diagnostic_signs = 0
let g:ycm_filetype_blacklist = {}
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/youcompleteme/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_rust_src_path = '~/.multirust/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src'
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_show_diagnostics_ui = 1

nnoremap <leader>J :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>j :YcmCompleter GoTo<CR>
nnoremap ycp :YcmCompleter GetParent<CR>
nnoremap yct :YcmCompleter GetType<CR>

set completeopt=menuone
