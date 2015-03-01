"---------------------------------------------------------------------------
" FileType PHP の設定
"---------------------------------------------------------------------------

" タブ幅の設定
set noexpandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

"---------------------------------------------------------------------------
" vimデフォルトのPHP設定
let php_noShortTags = 1

"---------------------------------------------------------------------------
" phpcomplete-extended
autocmd  FileType  php setlocal omnifunc=phpcomplete_extended#CompletePHP
let g:phpcomplete_index_composer_command = "composer"


"---------------------------------------------------------------------------
" ブロックの先頭を Preview Window で表示
nnoremap <buffer> <silent> ( :<C-U>call PreviewOpenBrace()<CR>

if !exists('*PreviewOpenBrace')
	function PreviewOpenBrace()
		let l:pos = getpos('.')
		if l:pos == get(s:, 'last_pos', [])
			let l:count = s:last_count + 1
		else
			let l:count = v:count1
		endif
		pclose
		pedit
		wincmd p
		execute 'normal!' l:count . '[{'
		setlocal cursorline
		wincmd p
		let s:last_count = l:count
		let s:last_pos   = l:pos
	endfunction
endif
