" タブ幅の設定
set noexpandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" Goのsyntastic設定
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
