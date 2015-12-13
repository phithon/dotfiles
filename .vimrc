" デフォルトの文字コードをUTF-8にする
set encoding=utf-8
set termencoding=cp932
" タブの画面上での表示幅
set tabstop=4
" タブをスペースに展開する
set expandtab
" インデントサイズ
set shiftwidth=4
" 上手くインデントする
set autoindent
" 行番号を表示
set number
" 検索結果のハイライト
set incsearch
" 数値コマンドを10進数として判定
set nrformats=
" アクティブなファイルのディレクトリーを手早く展開
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
" %でタグ間なども飛べるようにする
runtime macros/matchit.vim
" 未保存のファイルがあってもバッファを切り替えられる
set hidden
" タブを表示
set showtabline=2
" 移動用ショートカット
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>
nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [Q :cfirst<CR>
nnoremap <silent> ]Q :clast<CR>
nnoremap <silent> [e :lprevious<CR>
nnoremap <silent> ]e :lnext<CR>
nnoremap <silent> [E :lfirst<CR>
nnoremap <silent> ]E :llast<CR>
" ファイル名にスラッシュを使う
set shellslash
" 勝手に折り返さない
autocmd FileType text setlocal textwidth=0
" 長い行も途中まで表示
set display=lastline
" 表示行で移動
nnoremap <silent> j gj
nnoremap <silent> k gk
" ステータス行を2行に
set laststatus=2
" ステータスバーに色々表示
set statusline=%t%m%r%h%w%y%q[%{&fenc!=''?&fenc:&enc}:%{&ff}]\ \ %l\:%c\ \ %=%<%{expand('%:p')}
" バックアップファイルを作らない
set nobackup
" スワップファイルをまとめる
set directory=$HOME/.vim/swapfiles//
" 外部で変更されたファイルを自動的に再読み込み
set autoread

" NeoBundle
" Note: Skip initialization for vim-tiny or vim-small.
if !1 | finish | endif

if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif

  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
" Refer to |:NeoBundle-examples|.
" Note: You don't set neobundle setting in .gvimrc!
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'scrooloose/syntastic'

call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

let g:user_emmet_settings = {'variables': {'lang': 'ja'}}
" syntastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['jshint']

