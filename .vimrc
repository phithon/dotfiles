" タブの画面上での表示幅
set tabstop=4
" タブをスペースに展開する
set expandtab
" インデントサイズ
set shiftwidth=4
" 行番号を表示
set number
" 数値コマンドを10進数として判定
set nrformats=
" アクティブなファイルのディレクトリーを手早く展開
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'\' : '%%'
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
" ファイル名にスラッシュを使う
set shellslash
" 勝手に折り返さない
autocmd FileType text setlocal textwidth=0
" ステータスバーに色々表示
set statusline=%t%m%r%h%w%y%q[%{&fenc!=''?&fenc:&enc}:%{&ff}]\ \ %l\:%c\ \ %=%<%{expand('%:p')}
" バックアップファイルを作らない
set nobackup

