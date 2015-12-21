" フォントの設定
set guifont=MS_Gothic:h10:cSHIFTJIS
set printfont=MS_Gothic:h10:cSHIFTJIS

if has('multi_byte_ime') || has('xim')
  " IME有効時はカーソルを紫に
  highlight CursorIM guibg=Purple guifg=NONE
  " 挿入モード・検索モードでIMEはデフォルト無効に
  set iminsert=0 imsearch=0
endif

" メニューバーとツールバーを消す
set guioptions-=m
set guioptions-=T

