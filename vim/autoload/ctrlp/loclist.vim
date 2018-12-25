if exists('g:loaded_ctrlp_loclist') && g:loaded_ctrlp_loclist
    finish
en
let g:loaded_ctrlp_loclist = 1

cal add(g:ctrlp_ext_vars, {
    \ 'init': 'ctrlp#loclist#init()',
    \ 'accept': 'ctrlp#loclist#accept',
    \ 'lname': 'loclist',
    \ 'sname': 'loclist',
    \ 'type': 'line',
    \ 'sort': 0,
    \ 'nolim': 1,
    \ })

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

function! s:lineout(dict)
    retu printf('%s|%d:%d| %s', bufname(a:dict['bufnr']), a:dict['lnum'],
                \ a:dict['col'], matchstr(a:dict['text'], '\s*\zs.*\S'))
endf

function! s:syntax()
    if !ctrlp#nosy()
        cal ctrlp#hicheck('CtrlPqfLineCol', 'Search')
        sy match CtrlPqfLineCol '|\zs\d\+:\d\+\ze|'
    en
endf

function! ctrlp#loclist#init()
    cal s:syntax()
    retu map(getloclist('%'), 's:lineout(v:val)')
endf

function! ctrlp#loclist#accept(mode, str)
    let vals = matchlist(a:str, '^\([^|]\+\ze\)|\(\d\+\):\(\d\+\)|')
    if vals == [] || vals[1] == '' | retu | en
    cal ctrlp#acceptfile(a:mode, vals[1])
    let cur_pos = getpos('.')[1:2]
    if cur_pos != [1, 1] && cur_pos != map(vals[2:3], 'str2nr(v:val)')
        mark '
    en
    cal cursor(vals[2], vals[3])
    sil! norm! zvzz
endf

function! ctrlp#loclist#id()
    retu s:id
endf
