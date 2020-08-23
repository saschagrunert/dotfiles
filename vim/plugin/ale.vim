let g:airline#extensions#ale#enabled = 1
let g:ale_fix_on_save = 1
let g:ale_sign_error = '✖'
let g:ale_sign_warning = '⚠'
let g:ale_sign_info = 'ℹ'
let g:ale_linters = {
    \ 'asciidoc': [ 'alex', 'textlint', 'proselint', 'write-good' ],
    \ 'go': [ 'golangci-lint' ],
    \ 'haskell': [
        \ 'stack-build',
        \ 'hlint',
        \ 'hie',
        \ 'hdevtools' ],
    \ 'c': [],
    \ 'cpp': [],
    \ 'html': [],
    \ 'markdown': [ 'alex', 'textlint', 'proselint', 'write-good' ],
    \ 'rust': [ 'cargo', 'rustc' ],
    \ }
let g:ale_fixers = {
    \ '*': ['remove_trailing_lines', 'trim_whitespace'],
    \ 'asciidoc': [ 'textlint' ],
    \ 'c': [ 'clang-format' ],
    \ 'cpp': [ 'clang-format' ],
    \ 'css': [ 'prettier' ],
    \ 'go': [ 'gofmt', 'goimports' ],
    \ 'haskell': [ 'floskell', 'hlint' ],
    \ 'html': [ 'prettier' ],
    \ 'less': [ 'prettier' ],
    \ 'javascript': [ 'prettier' ],
    \ 'json': [ 'prettier' ],
    \ 'markdown': [ 'prettier', 'textlint' ],
    \ 'nix': [ 'nixpkgs-fmt' ],
    \ 'python': [ 'autopep8', 'yapf', 'isort' ],
    \ 'rust': [ 'rustfmt' ],
    \ 'scss': [ 'prettier' ],
    \ 'sh': [ 'shfmt' ],
    \ 'terraform': [ 'terraform' ],
    \ 'typescript': [ 'prettier' ],
    \ }
let g:ale_sh_shfmt_options = '-i 4'
let g:ale_go_golangci_lint_package = 1
let g:ale_go_golangci_lint_options = '--fast'
