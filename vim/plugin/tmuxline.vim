let g:tmuxline_preset = {
   \ 'a': '#{?client_prefix,[PREFIX] - ,}#S',
   \ 'b': '#F',
   \ 'c': ['#(~/.vim/scripts/pwd)', '#(~/.vim/scripts/branch)#(~/.vim/scripts/modified)#(~/.vim/scripts/staged)#(~/.vim/scripts/stashed)#(~/.vim/scripts/compare) #(~/.vim/scripts/rainbarf)#[fg=#44475a,bg=#44475a]'],
   \ 'win': ['#I', '#W'],
   \ 'cwin': ['#I', '#W'],
   \ 'x': ['#(~/.vim/scripts/ip)'],
   \ 'y': ['%a', '%d. %b', '%R'],
   \ 'z': ['  #H']
   \ }

call tmuxline#api#set_theme({
    \ 'a': ['#282a36', '#bd93f9', ''],
    \ 'b': ['#f8f8f2', '#6272a4', ''],
    \ 'c': ['#f8f8f2', '#44475a', ''],
    \ 'bg': ['#282a36', '#282a36', ''],
    \ 'cwin': ['#282a36', '#50fa7b', ''],
    \ 'win': ['#f8f8f2', '#282a36', ''],
    \ 'x': ['#f8f8f2', '#44475a', ''],
    \ 'y': ['#f8f8f2', '#6272a4', ''],
    \ 'z': ['#282A36', '#BD93F9', '']})
