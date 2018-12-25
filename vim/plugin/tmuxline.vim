 let g:tmuxline_preset = {
    \ 'a': '#{?client_prefix,[PREFIX] - ,}#S',
    \ 'b': '#F',
    \ 'c': ['#(~/.vim/scripts/pwd)', '#(~/.vim/scripts/branch)#(~/.vim/scripts/modified)#(~/.vim/scripts/staged)#(~/.vim/scripts/stashed)#(~/.vim/scripts/compare) #(~/.vim/scripts/rainbarf)'],
    \ 'win': ['#I', '#W'],
    \ 'cwin': ['#I', '#W'],
    \ 'x': ['#(~/.vim/scripts/ip)'],
    \ 'y': ['%a', '%d. %b', '%R'],
    \ 'z': [' #H']
    \ }
