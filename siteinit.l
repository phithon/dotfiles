;;; 基本設定
;; デフォルトの文字コードをUTF-8にする
(setq *default-fileio-encoding* *encoding-utf8n*)
;; インクリメンタルサーチを有効化
(require "isearch")
;; 削除処理をUNDOしたら戻った文字列の末尾へ
(setq *move-forward-after-undo-deletion* t)
;; C-x C-wをEmacsと同じにする
(define-key ctl-x-map #\C-w 'emacs-write-file)
;; シンボリックリンクの編集時にリンクを切らない
(setf backup-by-copying t)

;;; キーバインディングの設定
;; Alt-rで正規表現置換
(global-set-key #\M-r 'query-replace-regexp)
;; C-x hでバッファ全体を選択
(define-key ctl-x-map #\h 'selection-whole-buffer)

;;; Git
;; C-x cで開くシェルをGit Bashにする
(setf *eshell* "C:\\Program Files (x86)\\Git\\bin\\sh.exe --login -i")

;;; javascript-mode
(load-library "javascript-mode")
(push '("\\.js$" . javascript-mode) *auto-mode-alist*)

;;; scala-mode
(require "scala-mode")
(push '("\\.scala$" . ed::scala-mode) *auto-mode-alist*)
