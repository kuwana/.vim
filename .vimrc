" vim:set ts=8 sts=2 sw=2 tw=0: (この行に関しては:help modelineを参照)
"
" An example for a Japanese version vimrc file.
" 日本語版のデフォルト設定ファイル(vimrc) - Vim7用試作
"
" Last Change: 12-Jan-2016.
" Maintainer:  MURAOKA Taro <koron.kaoriya@gmail.com>
"
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
for path in split(glob($HOME.'/vimfiles/*'), '\n')
  if isdirectory(path) | let &runtimepath = &runtimepath.','.path | end
endfor


"---------------------------------------------------------------------------
" 日本語対応のための設定:
"
" ファイルを読込む時にトライする文字エンコードの順序を確定する。漢字コード自
" 動判別機能を利用する場合には別途iconv.dllが必要。iconv.dllについては
" README_w32j.txtを参照。ユーティリティスクリプトを読み込むことで設定される。
" source $VIM/plugins/kaoriya/encode_japan.vim
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
" 検索の挙動に関する設定:
"
" 検索時に大文字小文字を無視 (noignorecase:無視しない)
set ignorecase
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase

"---------------------------------------------------------------------------
" 編集に関する設定:
"
" タブをスペースに展開しない (expandtab:展開する)
set expandtab
" タブの画面上での幅
set tabstop=4
set softtabstop=4
set shiftwidth=4
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
set listchars=tab:\|\ ,extends:$,trail:_
" 長い行を折り返して表示 (nowrap:折り返さない)
set wrap
" 常にステータス行を表示 (詳細は:he laststatus)
set laststatus=2
" コマンドラインの高さ
set cmdheight=1
" コマンドをステータス行に表示
set showcmd
" タイトルを表示
set title
" 印刷設定
set printfont=Consolas:h8:cSHIFTJIS

"---------------------------------------------------------------------------
" その他、見栄えに関する設定:

"Esc連打でハイライト解除：
set hlsearch
nmap <Esc><Esc> :nohlsearch<CR><Esc>

" ビープ音消し、フラッシュ警告消し
set visualbell t_vb=
"---------------------------------------------------------------------------
" ファイル操作に関する設定:
"
" バックアップファイルを作成しない (次行の先頭の " を削除すれば有効になる)
"set nobackup
" バックアップファイルの出力先
set backupdir=~/.vim/tmp

" バックアップしないファイル
set backupskip=/tmp/*,/private/tmp/*

" スワップファイルの出力先
set directory=~/.vim/tmp

" アンドゥーファイルの出力先
set undodir=~/.vim/tmp

" 開いてるファイルを外部プログラムから変更があった際自動リロード
set autoread

" 全角文字をちゃんと表示
set ambiwidth=double

" 括弧の補完
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap [<Enter> []<Left><CR><ESC><S-o>
inoremap (<Enter> ()<Left><CR><ESC><S-o>
set timeout timeoutlen=1000 ttimeoutlen=75

"---------------------------------------------------------------------------
" ファイル名に大文字小文字の区別がないシステム用の設定:
"   (例: DOS/Windows/MacOS)
"
if filereadable($VIM . '/vimrc') && filereadable($VIM . '/ViMrC')
  " tagsファイルの重複防止
  set tags=./tags,tags
endif

" Ctags 生成オプション
let g:auto_ctags_tags_args = '-R'

" JSONのダブルクォート非表示を無効化
let g:vim_json_syntax_conceal = 0

" コンソール版色の設定
set t_Co=256
" colorscheme xoria256
colorscheme atom-dark-256

"---------------------------------------------------------------------------
" 補完ポップアップの背景色変更(コンソール版Vim用)
hi Pmenu ctermbg=0
hi PmenuSel ctermbg=4
hi PmenuSbar ctermbg=2
hi PmenuThumb ctermfg=3

" 警告メッセージを非表示に
hi WarningMsg guifg=bg


"---------------------------------------------------------------------------
" SQLのシンタックスをMySQLに
let g:sql_type_default = 'mysql'

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
"syntastic設定
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }

"---------------------------------------------------------------------------
"emmet-vim
"let g:user_emmet_leader_key='<C-M>'
let g:user_emmet_mode='n'    "only enable normal mode functions.

"---------------------------------------------------------------------------
" caw.vim
nmap <C-_> <Plug>(caw:i:toggle)
vmap <C-_> <Plug>(caw:i:toggle)

"---------------------------------------------------------------------------
" キーバインド一般
" C-cでESCと同じ動きに
inoremap <C-c> <ESC>

"---------------------------------------------------------------------------
"XML/HTMLの閉じタグ自動補完
augroup MyXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
  "autocmd Filetype php inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype eruby inoremap <buffer> </ </<C-x><C-o>
augroup END

"---------------------------------------------------------------------------
"NERDTree
nnoremap <silent> ,t :NERDTreeToggle<CR>

"---------------------------------------------------------------------------
"vimデフォルトのエクスプローラをvimfilerで置き換える
let g:vimfiler_as_default_explorer = 1
"セーフモードを無効にした状態で起動する
let g:vimfiler_safe_mode_by_default = 0
"現在開いているバッファのディレクトリを開く
nnoremap <silent> <Leader>fe :<C-u>VimFilerBufferDir -quit<CR>
"現在開いているバッファをIDE風に開く
nnoremap <silent> <Leader>fi :<C-u>VimFilerBufferDir -split -simple -winwidth=35 -no-quit<CR>
"---------------------------------------------------------------------------
"vimgrepを使いやすくする設定
command! -complete=file -nargs=+ Grep call s:grep([<f-args>])
function! s:grep(args)
    let target = len(a:args) > 1 ? join(a:args[1:]) : '**/*'
    execute 'vimgrep' '/' . a:args[0] . '/j ' . target
    if len(getqflist()) != 0 | copen | endif
endfunction

"---------------------------------------------------------------------------
"QuickRun設定
"
"g:quickrun_config の初期化
if !exists("g:quickrun_config")
    let g:quickrun_config = {
\   "_" : {
\       "runner" : "vimproc",
\       "runner/vimproc/updatetime" : 10,
\   },
\   'objc': {
\     'command': 'cc',
\     'exec': ['%c %s -o %s:p:r -framework Foundation', '%s:p:r %a', 'rm -f %s:p:r'],
\     'tempfile': '{tempname()}.m',
\   },
\}
endif


"分割で開く方向
set splitbelow "下に開く
set splitright "右に開く

"---------------------------------------------------------------------------
" Force.com vim plugin setting
let g:apex_tooling_force_dot_com_path = ""
let g:apex_temp_folder="/var/log/apex"
let g:apex_deployment_error_log="gvim-deployment-error.log"

"---------------------------------------------------------------------------
" taglist.vim
nnoremap <silent> <Space>tl :Tlist<CR>

"---------------------------------------------------------------------------
" CtrlP
nnoremap <silent> ,cp :CtrlPClearAllCaches<CR>
let g:ctrlp_custom_ignore = 'node_modules$\|DS_Store$\|\.git$'


"---------------------------------------------------------------------------
" SrcExpl

" 手動でプレビュー
let g:SrcExpl_RefreshTime = 0
" 起動時ctagsを自動実行(オフ)
let g:SrcExpl_UpdateTags = 0
let g:SrcExpl_RefreshMapKey = "<C-Space>"
nmap <F8> :SrcExplToggle<CR>

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
"タグジャンプ
nnoremap <silent> [unite]e :<C-u>Unite tag<CR>
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
"Unite Codic で英訳
nnoremap <silent> [unite]t :<C-u>Unite codic<CR>
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

"---------------------------------------------------------------------------
" javascriptファイルでjsxシンタックスを読み込む
let g:jsx_ext_required = 0

"---------------------------------------------------------------------------
" Agコマンド
nnoremap <Space>ag :<C-u>Ag 

" golang
autocmd FileType go autocmd BufWritePre <buffer> Fmt
let g:go_fmt_command = "goimports"
set rtp+=$GOROOT/misc/vim
exe "set rtp+=".globpath($GOPATH, "src/github.com/nsf/gocode/vim")

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags

" <TAB>: completion. TABで補完
"inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"


" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

"--------------------------------------------
" vim-easy-align

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"--------------------------------------------
" vdebug
let g:vdebug_options = {
  \ 'port' : 9001
\ }

"--------------------------------------------
" ayncomplete.vim
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"


"--------------------------------------------
" Jetpack.vim でプラグイン管理
packadd vim-jetpack
call jetpack#begin()
Jetpack 'tani/vim-jetpack', {'opt': 1} "bootstrap
Jetpack 'vim-airline/vim-airline'
Jetpack 'vim-airline/vim-airline-themes'
Jetpack 'ctrlpvim/ctrlp.vim'
Jetpack 'preservim/nerdtree'
Jetpack 'matze/vim-move'         " 行移動
Jetpack 'cohama/lexima.vim'      " 括弧補完
Jetpack 'tyru/caw.vim'            " コメント化
Jetpack 'thinca/vim-quickrun'
Jetpack 'prabirshrestha/async.vim'
Jetpack 'junegunn/fzf', { 'do': { -> fzf#install() } }
Jetpack 'junegunn/fzf.vim'
Jetpack 'prabirshrestha/asyncomplete.vim'
Jetpack 'prabirshrestha/asyncomplete-flow.vim'
Jetpack 'prabirshrestha/asyncomplete-buffer.vim'
Jetpack 'prabirshrestha/asyncomplete-file.vim'
Jetpack 'yami-beta/asyncomplete-omni.vim'
call jetpack#end()

" Powerline 設定
" Powerline系フォントを利用する
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 1
let g:airline_theme = 'luna'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.maxlinenr = '㏑'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.maxlinenr = ''


"--------------------------------------------
" Copyright (C) 2011 KaoriYa/MURAOKA Taro
