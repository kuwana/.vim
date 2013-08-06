" vim:set ts=8 sts=2 sw=2 tw=0: (この行に関しては:help modelineを参照)
"
" An example for a Japanese version vimrc file.
" 日本語版のデフォルト設定ファイル(vimrc) - Vim7用試作
"
" Last Change: 19-Nov-2012.
" Maintainer:  MURAOKA Taro <koron.kaoriya@gmail.com>
"
" 解説:
" このファイルにはVimの起動時に必ず設定される、編集時の挙動に関する設定が書
" かれています。GUIに関する設定はgvimrcに書かかれています。
"
" 個人用設定は_vimrcというファイルを作成しそこで行ないます。_vimrcはこのファ
" イルの後に読込まれるため、ここに書かれた内容を上書きして設定することが出来
" ます。_vimrcは$HOMEまたは$VIMに置いておく必要があります。$HOMEは$VIMよりも
" 優先され、$HOMEでみつかった場合$VIMは読込まれません。
"
" 管理者向けに本設定ファイルを直接書き換えずに済ませることを目的として、サイ
" トローカルな設定を別ファイルで行なえるように配慮してあります。Vim起動時に
" サイトローカルな設定ファイル($VIM/vimrc_local.vim)が存在するならば、本設定
" ファイルの主要部分が読み込まれる前に自動的に読み込みます。
"
" 読み込み後、変数g:vimrc_local_finishが非0の値に設定されていた場合には本設
" 定ファイルに書かれた内容は一切実行されません。デフォルト動作を全て差し替え
" たい場合に利用して下さい。
"
" 参考:
"   :help vimrc
"   :echo $HOME
"   :echo $VIM
"   :version

"---------------------------------------------------------------------------
" サイトローカルな設定($VIM/vimrc_local.vim)があれば読み込む。読み込んだ後に
" 変数g:vimrc_local_finishに非0な値が設定されていた場合には、それ以上の設定
" ファイルの読込を中止する。
if 1 && filereadable($VIM . '/vimrc_local.vim')
  unlet! g:vimrc_local_finish
  source $VIM/vimrc_local.vim
  if exists('g:vimrc_local_finish') && g:vimrc_local_finish != 0
    finish
  endif
endif

"---------------------------------------------------------------------------
" ユーザ優先設定($HOME/.vimrc_first.vim)があれば読み込む。読み込んだ後に変数
" g:vimrc_first_finishに非0な値が設定されていた場合には、それ以上の設定ファ
" イルの読込を中止する。
if 0 && exists('$HOME') && filereadable($HOME . '/.vimrc_first.vim')
  unlet! g:vimrc_first_finish
  source $HOME/.vimrc_first.vim
  if exists('g:vimrc_first_finish') && g:vimrc_first_finish != 0
    finish
  endif
endif

" plugins下のディレクトリをruntimepathへ追加する。
for path in split(glob($VIM.'/plugins/*'), '\n')
  if isdirectory(path) | let &runtimepath = &runtimepath.','.path | end
endfor
for path in split(glob($HOME.'/.vim/*'), '\n')
  if isdirectory(path) | let &runtimepath = &runtimepath.','.path | end
endfor

"---------------------------------------------------------------------------
" 日本語対応のための設定:
"
" ファイルを読込む時にトライする文字エンコードの順序を確定する。漢字コード自
" 動判別機能を利用する場合には別途iconv.dllが必要。iconv.dllについては
" README_w32j.txtを参照。ユーティリティスクリプトを読み込むことで設定される。
"source $VIM/plugins/kaoriya/encode_japan.vim
" メッセージを日本語にする (Windowsでは自動的に判断・設定されている)
if !(has('win32') || has('mac')) && has('multi_lang')
  if !exists('$LANG') || $LANG.'X' ==# 'X'
    if !exists('$LC_CTYPE') || $LC_CTYPE.'X' ==# 'X'
      language ctype ja_JP.eucJP
    endif
    if !exists('$LC_MESSAGES') || $LC_MESSAGES.'X' ==# 'X'
      language messages ja_JP.eucJP
    endif
  endif
endif
" MacOS Xメニューの日本語化 (メニュー表示前に行なう必要がある)
if has('mac')
  set langmenu=japanese
endif
" 日本語入力用のkeymapの設定例 (コメントアウト)
if has('keymap')
  " ローマ字仮名のkeymap
  "silent! set keymap=japanese
  "set iminsert=0 imsearch=0
endif
" 非GUI日本語コンソールを使っている場合の設定
if !has('gui_running') && &encoding != 'cp932' && &term == 'win32'
  set termencoding=cp932
  set encoding=utf-8
endif

"---------------------------------------------------------------------------
" メニューファイルが存在しない場合は予め'guioptions'を調整しておく
if 1 && !filereadable($VIMRUNTIME . '/menu.vim') && has('gui_running')
  set guioptions+=M
endif

"---------------------------------------------------------------------------
" Bram氏の提供する設定例をインクルード (別ファイル:vimrc_example.vim)。これ
" 以前にg:no_vimrc_exampleに非0な値を設定しておけばインクルードはしない。
if 1 && (!exists('g:no_vimrc_example') || g:no_vimrc_example == 0)
  if &guioptions !~# "M"
    " vimrc_example.vimを読み込む時はguioptionsにMフラグをつけて、syntax on
    " やfiletype plugin onが引き起こすmenu.vimの読み込みを避ける。こうしない
    " とencに対応するメニューファイルが読み込まれてしまい、これの後で読み込
    " まれる.vimrcでencが設定された場合にその設定が反映されずメニューが文字
    " 化けてしまう。
    set guioptions+=M
    source $VIMRUNTIME/vimrc_example.vim
    set guioptions-=M
  else
    source $VIMRUNTIME/vimrc_example.vim
  endif
endif

"---------------------------------------------------------------------------
" 検索の挙動に関する設定:
"
" 検索時に大文字小文字を無視 (noignorecase:無視しない)
set ignorecase
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase

"---------------------------------------------------------------------------
" 編集に関する設定:
"
" タブの画面上での幅
set tabstop=4
" タブをスペースに展開しない (expandtab:展開する)
set noexpandtab
" 自動的にインデントする (noautoindent:インデントしない)
set autoindent
" バックスペースでインデントや改行を削除できるようにする
set backspace=indent,eol,start
" 検索時にファイルの最後まで行ったら最初に戻る (nowrapscan:戻らない)
set wrapscan
" 括弧入力時に対応する括弧を表示 (noshowmatch:表示しない)
set showmatch
" コマンドライン補完するときに強化されたものを使う(参照 :help wildmenu)
set wildmenu
" テキスト挿入中の自動折り返しを日本語に対応させる
set formatoptions+=mM
"
set softtabstop=4
set shiftwidth=4
"--------------------------------------

"---------------------------------------------------------------------------
" GUI固有ではない画面表示の設定:
"
" 行番号を非表示 (number:表示)
set number
" ルーラーを表示 (noruler:非表示)
set ruler
" タブや改行を表示 (list:表示)
set list
" どの文字でタブや改行を表示するかを設定
set listchars=tab:>\ ,extends:$,trail:_
" 長い行を折り返して表示 (nowrap:折り返さない)
set wrap
" 常にステータス行を表示 (詳細は:he laststatus)
set laststatus=2
" コマンドラインの高さ (Windows用gvim使用時はgvimrcを編集すること)
set cmdheight=2
" コマンドをステータス行に表示
set showcmd
" タイトルを表示
set title
" 印刷設定
"set printfont=Consolas:h8:cSHIFTJIS
set printfont=Ricty:h8:EUC-JP
" カーソル行を強調表示しない
set nocursorline
" 挿入モードの時のみ、カーソル行をハイライトする
autocmd InsertEnter,InsertLeave * set cursorline!
"Esc連打でハイライト解除：
set hlsearch
nmap <Esc><Esc> :nohlsearch<CR><Esc>

"---------------------------------------------------------------------------
" ファイル操作に関する設定:
"
" バックアップファイルを作成しない (次行の先頭の " を削除すれば有効になる)
"set nobackup
" バックアップファイルの出力先
set backupdir=~/.vim/tmp

" スワップファイルの出力先
set directory=~/.vim/tmp

"---------------------------------------------------------------------------
" ファイル名に大文字小文字の区別がないシステム用の設定:
"   (例: DOS/Windows/MacOS)
"
if filereadable($VIM . '/vimrc') && filereadable($VIM . '/ViMrC')
  " tagsファイルの重複防止
  set tags=./tags,tags
endif

" タグリスト
nnoremap <silent> <space>tl :Tlist<CR>

"---------------------------------------------------------------------------
" コンソールでのカラー表示のための設定(暫定的にUNIX専用)
if has('unix') && !has('gui_running')
  let uname = system('uname')
  if uname =~? "linux"
    set term=builtin_linux
  elseif uname =~? "freebsd"
    set term=builtin_cons25
  elseif uname =~? "Darwin"
    set term=beos-ansi
  else
    set term=builtin_xterm
  endif
  unlet uname
endif

" コンソール版色の設定
set t_Co=256
colorscheme xoria256
"colorscheme ron

"---------------------------------------------------------------------------
" コンソール版で環境変数$DISPLAYが設定されていると起動が遅くなる件へ対応
if !has('gui_running') && has('xterm_clipboard')
  set clipboard=exclude:cons\\\|linux\\\|cygwin\\\|rxvt\\\|screen
endif

"---------------------------------------------------------------------------
" プラットホーム依存の特別な設定

" WinではPATHに$VIMが含まれていないときにexeを見つけ出せないので修正
if has('win32') && $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
  let $PATH = $VIM . ';' . $PATH
endif

if has('mac')
  " Macではデフォルトの'iskeyword'がcp932に対応しきれていないので修正
  set iskeyword=@,48-57,_,128-167,224-235
endif

"---------------------------------------------------------------------------
" KaoriYaでバンドルしているプラグインのための設定

" autofmt: 日本語文章のフォーマット(折り返し)プラグイン.
"set formatexpr=autofmt#japanese#formatexpr()
"---------------------------------------------------------------------------
" evernoteに送るプラグイン
"nmap ,n :w $HOME/Documents/Evernote Inport<CR>
"---------------------------------------------------------------------------
"bundle以下をプラグインとして読み込む設定
call pathogen#infect()
call pathogen#helptags()
syntax on
filetype plugin indent on

"---------------------------------------------------------------------------
"  VimOrganizer
au! BufRead,BufWrite,BufWritePost,BufNewFile *.org 
au BufEnter *.org            call org#SetOrgFileType()
"let g:org_command_for_emacsclient = 'D:\program\emacs-23.3\bin\emacsclientw.exe'
"let g:org_agenda_select_dirs=["~/.vim_junk/org_files"]
"let g:org_agenda_files = split(glob("~/.vim_junk/org_files/*.org"),"\n")
"---------------------------------------------------------------------------
" neobundle.vim うまく動作しなかったので一旦保留

" <TAB>: completion. TABで補完
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

"set nocompatible
"filetype plugin indent off
 
"if has('vim_starting')
    "set runtimepath+=~/.vim/bundle/neobundle.vim/
"    call neobundle#rc(expand('~/vimfiles/bundle/'))
"endif
 
"NeoBundle 'git://github.com/Shougo/neobundle.vim.git'
"NeoBundle 'git://github.com/Shougo/neocomplcache.git'
"NeoBundle 'git://github.com/Shougo/unite.vim.git'
"NeoBundle 'git://github.com/Shougo/vimshell.git'
"NeoBundle 'git://github.com/Shougo/vimproc.git'
"NeoBundle 'http://github.com/mattn/zencoding-vim.git'
 
"filetype plugin on
"filetype indent on

"---------------------------------------------------------------------------
"vim-ref
"let $PATH = $PATH . ';C:\Program Files (x86)\Lynx for Win32'
"let g:ref_alc_encoding = 'SHIFT-JIS'

"---------------------------------------------------------------------------
"ZenCoding-Vimのヘルプファイル参照
helptags ~/.vim/bundle/zencoding-vim/doc
"ZenCoding実行のキーバインド変更
"let g:user_zen_leader_key = '<C-e>'


"---------------------------------------------------------------------------
" PHPの設定
let php_sql_query=1         "文字列のSQLをハイライト
let php_htmlInStrings=1     "文字列のHTMLをハイライト
let php_noShortTags=1       "ショートタグでハイライトしない<?はダメ
" let php_folding=1           "折りたたみ->糞重いのでphpfoldin.vimに代替。自動で有効

" PHP Lint
function PHPLint()
  let result = system( &ft . ' -l ' . bufname(""))
  echo result
endfunction

autocmd FileType php :nmap ,l :call PHPLint()
autocmd FileType php :set dictionary=~/.vim/dict/vim-dict-wordpress/*.dict

" PHP以外でも折りたたむ
augroup vimrc
  autocmd FileType phpunit EnableFastPHPFolds
augroup END

"phpmanualのパス
let g:ref_phpmanual_path='/home/takuya/Documents/php-chunked-xhtml'

"---------------------------------------------------------------------------
" CoffeeScriptの設定
autocmd BufWritePost *.coffee silent CoffeeMake! -cb | cwindow | redraw!

"---------------------------------------------------------------------------
" キーバインド一般
" C-cでESCと同じ動きに
inoremap <C-c> <ESC>
vmap <C-y> :w !xsel -ib<CR><CR>
"---------------------------------------------------------------------------
" XML/HTMLの閉じタグ自動補完
augroup MyXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
  "autocmd Filetype php inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype eruby inoremap <buffer> </ </<C-x><C-o>
augroup END
"---------------------------------------------------------------------------
" Vimshellのキーバインド
" ,is: シェルを起動
nnoremap <silent> ,is :VimShell<CR>
" ,iph: phpを非同期で起動
nnoremap <silent> ,iph :VimShellInteractive php<CR>
" ,irb: irbを非同期で起動
nnoremap <silent> ,irb :VimShellInteractive irb<CR>
" ,ss: 非同期で開いたインタプリタに現在の行を評価させる
vmap <silent> ,ss :VimShellSendString<CR>
" 選択中に,ss: 非同期で開いたインタプリタに選択行を評価させる
nnoremap <silent> ,ss <S-v>:VimShellSendString<CR>

"---------------------------------------------------------------------------
" vimデフォルトのエクスプローラをvimfilerで置き換える
let g:vimfiler_as_default_explorer = 1
" フモードを無効にした状態で起動する
let g:vimfiler_safe_mode_by_default = 0
" 現在開いているバッファのディレクトリを開く
nnoremap <silent> <Leader>fe :<C-u>VimFilerBufferDir -quit<CR>
" 現在開いているバッファをIDE風に開く
nnoremap <silent> <Leader>fi :<C-u>VimFilerBufferDir -split -simple -winwidth=35 -no-quit<CR>

"---------------------------------------------------------------------------
" vimgrepを使いやすくする設定
command! -complete=file -nargs=+ Grep call s:grep([<f-args>])
function! s:grep(args)
    let target = len(a:args) > 1 ? join(a:args[1:]) : '**/*'
    execute 'vimgrep' '/' . a:args[0] . '/j ' . target
    if len(getqflist()) != 0 | copen | endif
endfunction

"---------------------------------------------------------------------------
" netrw.vimの設定
" netrwは常にtree view
let g:netrw_liststyle = 3
" CVSと.で始まるファイルは表示しない
"let g:netrw_list_hide = 'CVS,\(^\|\s\s\)\zs\.\S\+'
" 'v'でファイルを開くときは右側に開く。(デフォルトが左側なので入れ替え)
let g:netrw_altv = 1
" 'o'でファイルを開くときは
let g:netrw_alto = 1

" Exploreのショートカット
nnoremap <silent> <space>o :Explore<CR>

"---------------------------------------------------------------------------
" QuickRun設定
"
"g:quickrun_config の初期化
if !exists("g:quickrun_config")
    let g:quickrun_config = {
\   "_" : {
\       "runner" : "vimproc",
\       "runner/vimproc/updatetime" : 10,
\   },
\}
endif

"分割で開く方向
set splitbelow "下に開く
set splitright "右に開く

"---------------------------------------------------------------------------
"Javaのシンタックスハイライト拡張設定
:let java_highlight_all=1
:let java_highlight_debug=1
:let java_space_errors=1
:let java_allow_cpp_keywords=1
:let java_highlight_functions=1

"コンバイラ設定
au FileType java compiler javac

"コンパイル
function! CompileJava()
	:make %
	:cw
endfunction

au FileType java nmap &lt;F5> :call CompileJava()&lt;CR>

"---------------------------------------------------------------------------
" Gist-vim prefix key

" List
nnoremap <silent> ,gl :Gist -l<CR>
" Stared List
nnoremap <silent> ,gs :Gist -ls<CR>
" Private Post
nnoremap <silent> ,gp :Gist -p<CR>
" Pablic Post
nnoremap <silent> ,gP :Gist -P<CR>
" Delete
nnoremap <silent> ,gD :Gist -d<CR>
" And more...
" :Gist -h

"---------------------------------------------------------------------------
"unite prefix key.
nnoremap [unite] <Nop>
nmap <Space>f [unite]

"unite general settings
"インサートモードで開始
let g:unite_enable_start_insert = 1
"最近開いたファイル履歴の保存数
let g:unite_source_file_mru_limit = 50

"file_mruの表示フォーマットを指定。空にすると表示スピードが高速化される
let g:unite_source_file_mru_filename_format = ''

"現在開いているファイルのディレクトリ下のファイル一覧。
"開いていない場合はカレントディレクトリ
nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
"バッファ一覧
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
"Everything検索
nnoremap <silent> [unite]e :<C-u>Unite everything<CR>
"レジスタ一覧
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>
"最近使用したファイル一覧
nnoremap <silent> [unite]m :<C-u>Unite file_mru<CR>
"アウトライン表示
nnoremap <silent> [unite]o :<C-u>Unite outline<CR>
"ブックマーク一覧
nnoremap <silent> [unite]c :<C-u>Unite bookmark<CR>
"ブックマークに追加
nnoremap <silent> [unite]a :<C-u>UniteBookmarkAdd<CR>
"uniteを開いている間のキーマッピング
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()"{{{
"ESCでuniteを終了
nmap <buffer> <ESC> <Plug>(unite_exit)
"入力モードのときjjでノーマルモードに移動
imap <buffer> jj <Plug>(unite_insert_leave)
"入力モードのときctrl+wでバックスラッシュも削除
imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
"ctrl+jで縦に分割して開く
nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
"ctrl+jで横に分割して開く
nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
"ctrl+oでその場所に開く
nnoremap <silent> <buffer> <expr> <C-o> unite#do_action('open')
inoremap <silent> <buffer> <expr> <C-o> unite#do_action('open')
endfunction"}}}

"--------------------------------------------
" neocomplcache
let g:neocomplcache_enable_at_startup = 1 " 起動時に有効化

"--------------------------------------------
" powerline
let g:Powerline_symbols = 'fancy'

" Copyright (C) 2011 KaoriYa/MURAOKA Taro
