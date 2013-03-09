""
" Java Lint コンパイル情報を表示する
nmap ,l :execute '!javac -verbose %'<CR>

" ブロックの先頭を表示
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
