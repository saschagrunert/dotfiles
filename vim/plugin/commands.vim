" count matches
command Matches :%s///gn

" kill whitespace
command! KillWhitespace :%s/\s\+$//
command! KillEmptyLines :normal GoZ<Esc>:g/^$/.,/./-j<CR>Gdd
command! KillBlankLines :normal GoZ<Esc>:g/^[ <Tab>]*$/.,/[^ <Tab>]/-j<CR>Gdd

" Remove all unopen buffers
command! -bang Wipeout :call Wipeout(<bang>0)

" execute a command for every item in the quickfix list
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
command! -nargs=1 -complete=command -bang Qargdo exe 'args '.QuickfixFilenames() | argdo<bang> <args>

" toggle hex mode
command -bar Hexmode call ToggleHex()

" remove all buffers, but not the current
command! -nargs=? -complete=buffer -bang BufOnly :call BufOnly('<args>', '<bang>')

" pretty print json
command! PrettyJSON :%!python -m json.tool

" howdoi interface
command! -nargs=? HowDoI :r!howdoi <args>

" fish
command! -nargs=? Fish :Dispatch fish -c "<args>"
