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
;; インデントでタブを使わない
(setf *lisp-indent-tabs-mode* nil)

;;; diff
;; MinGWのdiffを使う
(setf ed::*diff-command-name* "C:\\Progra~2\\Git\\bin\\diff.exe")
;; カレントバッファでdiff
; new file: 現在のバッファがファイルに紐づいていればこのバッファ、そうでなければファイルを指定する
; old file: 別ウィンドウに開いているバッファがファイルに紐づいていればそのバッファ、そうでなければファイルを指定する
(defun diff-current-buffers ()
  (interactive)
  (let ((current-file-name (get-buffer-file-name (selected-buffer)))
        (another-file-name (and (not (eq (count-windows) 1))
                                (get-buffer-file-name (window-buffer (next-window (selected-window)))))))
    (diff (or current-file-name (read-file-name "diff(new file): "))
          (or (and (not (eq current-file-name another-file-name)) another-file-name)
              (read-file-name "another file(older): ")))))
;; C-x dでカレントバッファのdiff
(define-key ctl-x-map #\d 'diff-current-buffers)

;;; キーバインディングの設定
;; Alt-rで正規表現置換
(global-set-key #\M-r 'query-replace-regexp)
;; C-x 3で画面を縦分割
(define-key ctl-x-map #\3 'split-window-vertically)
;; C-x hでバッファ全体を選択
(define-key ctl-x-map #\h 'selection-whole-buffer)

;;; Git
;; C-x cで開くシェルをGit Bashにする
(setf *eshell* "\"C:\\\\Program Files (x86)\\\\Git\\\\bin\\\\sh.exe\" --login -i")

;;; javascript-mode
(load-library "javascript-mode")
(push '("\\.js\\(on\\)?$" . javascript-mode) *auto-mode-alist*)
(setf *javascript-indent-tabs-mode* nil)

;;; scala-mode
(require "scala-mode")
(push '("\\.scala$" . ed::scala-mode) *auto-mode-alist*)
