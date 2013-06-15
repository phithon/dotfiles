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

;;; ファイラー
;; 削除時にごみ箱を経由する
(setf *filer-use-recycle-bin* t)
;; 開いているディレクトリーでシェルを起動
(define-key filer-keymap '(#\C-x #\c)
            #'(lambda ()
                (interactive)
                (call-process (or *eshell* *shell*) :no-std-handles t :show :show
                              :exec-directory (filer-get-directory))))

;;; paren
(require "paren")
(turn-on-global-paren)
; (setq-default *paren-highlight-only-paren* t)
; (setq-default *paren-continue-original-attribute* t)
(setq-default *paren-tag-highlight* nil)

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
(define-key ctl-x-map '(#\4 #\s) #'(lambda () (interactive) (find-file "~/site-lisp/siteinit.l")))
;; 括弧や文字列は勝手に閉じる
(defun define-auto-suffix (keymap key suffix)
  "add suffixes automatically"
  (define-key keymap key #'(lambda () (interactive "*") (insert key) (save-excursion (insert suffix)))))
(define-auto-suffix *global-keymap* #\{ "}")
(define-auto-suffix *global-keymap* #\[ "]")
(define-auto-suffix *global-keymap* #\( ")")
(define-auto-suffix *global-keymap* #\' "'")
(define-auto-suffix *global-keymap* #\" "\"")
;; 対応する括弧や引用符は勝手に消す
(defun delete-backward-char-or-suffix-or-selection-factory (prefix-suffix-pair-list)
  #'(lambda (&optional (n 1))
      (interactive "*p")
      ; selectionがあればそれを消す
      (if (pre-selection-p)
          (delete-selection)
        ; カーソル位置が接頭・接尾ペアに挟まれているかどうか各組み合わせについて確認し、一致するものがあればまとめて消す
        (if (not (dolist (element prefix-suffix-pair-list)
                   (let ((prefix (car element))
                         (suffix (cdr element)))
                     (if (and (string= prefix (buffer-substring (point) (save-excursion (backward-char (length prefix)) (point))))
                              (string= suffix (buffer-substring (point) (save-excursion (forward-char (length suffix)) (point)))))
                         (progn (delete-backward-char (length prefix))
                           (delete-char (length suffix))
                           (return t))))))
            ; マッチするものが無ければ普通のバックスペース
            (delete-backward-char n)))))

;;; Git
;; C-x cで開くシェルをGit Bashにする
(setf *eshell* "\"C:\\\\Program Files (x86)\\\\Git\\\\bin\\\\sh.exe\" --login -i")

;;; javascript-mode
(load-library "javascript-mode")
(push '("\\.js\\(on\\)?$" . javascript-mode) *auto-mode-alist*)
(setf *javascript-indent-tabs-mode* nil)
(define-key *javascript-mode-map* #\TAB 'javascript-indent-line)
(undefine-key *javascript-mode-map* #\.)
(define-key *javascript-mode-map* #\C-h
            (delete-backward-char-or-suffix-or-selection-factory
             '(("{"."}") ("[" . "]") ("(" . ")") ("'" . "'") ("\"" . "\""))))
;; インデントを何とかする
;; switch文のラベルと誤認されることへの対処
; var foo = {
;    bar: ←ここでインデントを4つにする
(setf c-label-offset 0)
;; オブジェクトの閉じ括弧がプロパティー行の継続行と誤認されることへの対処
; var foo = {
;     bar: 'baz'
; } ←ここでちゃんと左に寄せる
; 元のインデント関数の保持
(setf (symbol-function 'original-javascript-indent-line) #'javascript-indent-line)
; 現在行を文字列として取り出す関数
(defun current-line-string ()
  "get current line as string"
  (save-excursion (buffer-substring (progn (goto-bol) (point))
                                    (progn (goto-eol) (point)))))
(defun javascript-indent-line ()
  "revoke indent for right brases"
  (interactive "*")
  (if (not (string-match "^[ \t]*}" (current-line-string)))
      (progn (original-javascript-indent-line)
        ; 配列が余計にインデントされる現象への対処
        (if (string-match "^[ \t]\\{4\\}[ \t]*\\]" (current-line-string))
            (save-excursion
              (goto-bol)
              (scan-buffer "^[ \t]\\{4\\}\\([ \t]*\\)" :regexp t :limit (save-excursion (goto-eol) (point)))
              (replace-match "\\1"))))
    ; 現在行が閉じ括弧で始まる場合、継続行のインデントを一時的に0にする
    (let ((original-continued-offset c-continued-statement-offset))
      (setf c-continued-statement-offset 0)
      (original-javascript-indent-line)
      (setf c-continued-statement-offset original-continued-offset))))
;; 中括弧内で改行したら展開してカーソルを中に入れる
(defun javascript-newline-and-expand-brases (&optional (arg 1))
  "open brases and move the cursor inside of the brases"
  (interactive "*")
  (javascript-newline-and-indent arg)
  (flet ((current-line-string () (buffer-substring (progn (goto-bol) (point)) (progn (goto-eol) (point)))))
    (if (or (save-excursion (and (string-match "^[ \t]*}" (current-line-string)) ; {}内で改行した場合
                                 (string-match "{[ \t]*$" (progn (previous-line) (current-line-string)))))
            (save-excursion (and (string-match "^[ \t]*\\]" (current-line-string)) ; []内で改行した場合
                                 (string-match "\\[[ \t]*$" (progn (previous-line) (current-line-string))))))
        (progn (save-excursion (javascript-newline-and-indent arg))
          (javascript-indent-line)))))
(define-key *javascript-mode-map* #\RET 'javascript-newline-and-expand-brases)
(define-key *javascript-mode-map* #\LFD 'javascript-newline-and-expand-brases)

;;; scala-mode
(require "scala-mode")
(push '("\\.scala$" . ed::scala-mode) *auto-mode-alist*)
