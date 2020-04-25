let g:ycm_add_preview_to_completeopt = 1
let g:ycm_always_populate_location_list = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_complete_in_comments = 1
let g:ycm_confirm_extra_conf = 0
let g:ycm_disable_for_files_larger_than_kb = 5000
let g:ycm_error_symbol = '✖'
let g:ycm_filetype_blacklist = {}
let g:ycm_max_num_identifier_candidates = 25
let g:ycm_rust_src_path = '~/.multirust/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src'
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_warning_symbol = '⚠'

nnoremap <leader>J :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>j :YcmCompleter GoTo<CR>
nnoremap ycp :YcmCompleter GetParent<CR>
nnoremap yct :YcmCompleter GetType<CR>

set completeopt+=popup
