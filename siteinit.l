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
(define-key ctl-x-map '(#\2 #\f) #'(lambda () (interactive) (find-file "~/site-lisp/siteinit.l")))

;;; Git
;; C-x cで開くシェルをGit Bashにする
(setf *eshell* "\"C:\\\\Program Files (x86)\\\\Git\\\\bin\\\\sh.exe\" --login -i")

;;; javascript-mode
(load-library "javascript-mode")
(push '("\\.js\\(on\\)?$" . javascript-mode) *auto-mode-alist*)
(setf *javascript-indent-tabs-mode* nil)
(define-key *javascript-mode-map* #\TAB 'javascript-indent-line)
(undefine-key *javascript-mode-map* #\.)
;; インデントを何とかする
; 元のインデント関数の保持
(setf (symbol-function 'original-javascript-indent-line) #'javascript-indent-line)
; 上手くインデントする
(defun javascript-indent-line ()
  (interactive)
  ; オブジェクトのプロパティーの行がswitchのラベルに誤認されることへの対処
  (let ((original-label-offset c-label-offset))
    (setf c-label-offset 0)
    (if (not (string-match "^[ \t]+}" (buffer-substring (save-excursion (goto-bol) (point))
                                                        (save-excursion (goto-eol) (point)))))
        (original-javascript-indent-line)
      ; オブジェクトの閉じ括弧が前のプロパティー行の継続行と誤認されることへの対処
      (let ((original-continued-offset c-continued-statement-offset))
        (setf c-continued-statement-offset 0)
        (original-javascript-indent-line)
        (setf c-continued-statement-offset original-continued-offset)))
    (setf c-label-offset original-label-offset)))

;;; scala-mode
(require "scala-mode")
(push '("\\.scala$" . ed::scala-mode) *auto-mode-alist*)
