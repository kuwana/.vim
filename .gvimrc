" vim:set ts=8 sts=2 sw=2 tw=0: (この行に関しては:help modelineを参照)
"
" An example for a Japanese version gvimrc file.
" 日本語版のデフォルトGUI設定ファイル(gvimrc) - Vim7用試作
"
" Last Change: 01-Mar-2015.
" Maintainer:  MURAOKA Taro <koron.kaoriya@gmail.com>
"
" 参考:
"   :help gvimrc
"   :echo $HOME
"   :echo $VIM
"   :version

"---------------------------------------------------------------------------
" サイトローカルな設定($VIM/gvimrc_local.vim)があれば読み込む。読み込んだ後
" に変数g:gvimrc_local_finishに非0な値が設定されていた場合には、それ以上の設
" 定ファイルの読込を中止する。
if 1 && filereadable($VIM . '/gvimrc_local.vim')
  source $VIM/gvimrc_local.vim
  if exists('g:gvimrc_local_finish') && g:gvimrc_local_finish != 0
    finish
  endif
endif

"---------------------------------------------------------------------------
" ユーザ優先設定($HOME/.gvimrc_first.vim)があれば読み込む。読み込んだ後に変
" 数g:gvimrc_first_finishに非0な値が設定されていた場合には、それ以上の設定
" ファイルの読込を中止する。
if 0 && exists('$HOME') && filereadable($HOME . '/.gvimrc_first.vim')
  unlet! g:gvimrc_first_finish
  source $HOME/.gvimrc_first.vim
  if exists('g:gvimrc_first_finish') && g:gvimrc_first_finish != 0
    finish
  endif
endif

"---------------------------------------------------------------------------
" Bram氏の提供する設定例をインクルード (別ファイル:vimrc_example.vim)。これ
" 以前にg:no_gvimrc_exampleに非0な値を設定しておけばインクルードしない。
if 1 && (!exists('g:no_gvimrc_example') || g:no_gvimrc_example == 0)
  source $VIMRUNTIME/gvimrc_example.vim
endif

"---------------------------------------------------------------------------
" カラー設定:
"colorscheme mycolor
colorscheme slate2

"---------------------------------------------------------------------------
"追加分：
"firefoxで開く
noremap <Leader>W :silent ! start firefox %<CR>
nnoremap <Leader>0 :silent ! start "%"

"---------------------------------------------------------------------------
"tab <F2> 新規タブの作成
"tab <F3> 一つ前のタブへ
"tab <F4> 次のタブへ
"tab <F6> タブを閉じる(最後のタブページは閉じられない)

nmap <silent> <F2> <Esc>:tabnew<CR>:tabmove<CR>
nmap <silent> <F3> <Esc>:tabprevious<CR>
nmap <silent> <F4> <Esc>:tabnext<CR>
nmap <silent> <F6> <Esc>:tabc<CR>

"---------------------------------------------------------------------------
" フォント設定:
"
if has('win32')
  " Windows用
  set guifont=Consolas:h10.5:cSHIFTJIS
  "set guifont=MeiryoKe_Gothic:h12
  "set guifont=Lucida_Console:h12:w5:cSHIFTJIS
  " 行間隔の設定
  set linespace=1
  " 一部のUCS文字の幅を自動計測して決める
  if has('kaoriya')
    set ambiwidth=auto
  endif
elseif has('mac')
  " set guifont=Osaka－等幅:h14
  set guifont=Ricty_discord:h13
elseif has('xfontset')
  " UNIX用 (xfontsetを使用)
  "set guifontset=a14,r14,k14
endif

"linux用
"set guifont=Ricty\ 12

"---------------------------------------------------------------------------
" ウインドウに関する設定:
"
" ウインドウの幅
set columns=90
" ウインドウの高さ
set lines=42
" コマンドラインの高さ(GUI使用時)
set cmdheight=2
" 画面を黒地に白にする (次行の先頭の " を削除すれば有効になる)
"colorscheme evening " (GUI使用時)


"---------------------------------------------------------------------------
" 日本語入力に関する設定:
"
if has('multi_byte_ime') || has('xim')
  " IME ON時のカーソルの色を設定(設定例:紫)
  highlight CursorIM guibg=Purple guifg=NONE
  " 挿入モード・検索モードでのデフォルトのIME状態設定
  set iminsert=0 imsearch=0
  if has('xim') && has('GUI_GTK')
    " XIMの入力開始キーを設定:
    " 下記の s-space はShift+Spaceの意味でkinput2+canna用設定
    "set imactivatekey=s-space
  endif
  " 挿入モードでのIME状態を記憶させない場合、次行のコメントを解除
  "inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
endif

"---------------------------------------------------------------------------
" マウスに関する設定:
"
" 解説:
" mousefocusは幾つか問題(一例:ウィンドウを分割しているラインにカーソルがあっ
" ている時の挙動)があるのでデフォルトでは設定しない。Windowsではmousehide
" が、マウスカーソルをVimのタイトルバーに置き日本語を入力するとチラチラする
" という問題を引き起す。
"
" どのモードでもマウスを使えるようにする
set mouse=a
" マウスの移動でフォーカスを自動的に切替えない (mousefocus:切替る)
set nomousefocus
" 入力時にマウスポインタを隠す (nomousehide:隠さない)
set mousehide
" ビジュアル選択(D&D他)を自動的にクリップボードへ (:help guioptions_a)
"set guioptions+=a

"---------------------------------------------------------------------------
" メニューに関する設定:
"
" 解説:
" "M"オプションが指定されたときはメニュー("m")・ツールバー("T")供に登録され
" ないので、自動的にそれらの領域を削除するようにした。よって、デフォルトのそ
" れらを無視してユーザが独自の一式を登録した場合には、それらが表示されないと
" いう問題が生じ得る。しかしあまりにレアなケースであると考えられるので無視す
" る。
"
if &guioptions =~# 'M'
  let &guioptions = substitute(&guioptions, '[mT]', '', 'g')
endif

set guioptions-=m 
set guioptions-=T 

"---------------------------------------------------------------------------
" ポップアップメニューの色
hi Pmenu  guibg=#f5f5dc	guifg=#000000
hi PmenuSel guibg=#443333 guifg=#ffb038
hi PmenuSbar  guibg=#aaaaaa
hi PmenuThumb guifg=#443333

"---------------------------------------------------------------------------
" 印刷に関する設定:
"
" 注釈:
" 印刷はGUIでなくてもできるのでvimrcで設定したほうが良いかもしれない。この辺
" りはWindowsではかなり曖昧。一般的に印刷には明朝、と言われることがあるらし
" いのでデフォルトフォントは明朝にしておく。ゴシックを使いたい場合はコメント
" アウトしてあるprintfontを参考に。
"
" 参考:
"   :hardcopy
"   :help 'printfont'
"   :help printing
"
" 印刷用フォント
if has('printer')
  if has('win32')
    set printfont=Ricty:h8:EUC-JP
    "set printfont=MS_Gothic:h12:cSHIFTJIS
  endif
endif

set printfont=Ricty:h9:UTF-8

" 透過設定
"gui
"set transparency=238

" Copyright (C) 2011 KaoriYa/MURAOKA Taro
