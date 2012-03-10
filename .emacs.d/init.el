;; -----------------------------------------------------------------------------
;; 文字コードの設定

;; 言語を日本語にする
(set-language-environment 'Japanese)
;; 基本UTF-8
(prefer-coding-system 'utf-8)
;; macの場合
(when (eq system-type 'darwin)
  (require 'ucs-normalize)
  (set-file-name-coding-system 'utf-8-hfs)
  (setq locale-coding-system 'utf-8-hfs))
;; windowsの場合
(when (eq window-system 'w32)
  (set-file-name-coding-system 'cp932)
  (setq locale-coding-system 'cp932))

;;; -----------------------------------------------------------------------------
;;; 設定

;;; load-path を追加する関数を定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
	      (expand-file-name (concat user-emacs-directory path))))
	(add-to-list 'load-path default-directory)
	(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
	    (normal-top-level-add-subdirs-to-load-path))))))
;;; 引数のディレクトリとそのサブディレクトリをload-pathに追加
(add-to-load-path "elisp" "conf" "public_repos")

;;; 設定をconfから読み込む
;;; http://coderepos.org/share/browser/lang/elisp/init-loader/init-loader.el
(require 'init-loader)
(init-loader-load "~/.emacs.d/conf")

;;; -----------------------------------------------------------------------------
;;; キーバインド設定

(define-key global-map (kbd "C-m") 'newline-and-indent) ;改行＋インデント
(define-key global-map (kbd "C-t") 'other-window)	;他のウィンドウ

;;; -----------------------------------------------------
;;; 表示設定

;;; タイトルバーにフルパスを表示
(setq frame-title-format "%f")

;;; カラム番号も表示
(column-number-mode t)

;;; ファイルサイズ
(size-indication-mode t)

;;; 時計
(setq display-time-day-and-date t)
(setq display-time-24hr-format t)
(display-time-mode t)

;;; バッテリー残量
(display-battery-mode t)

;; リージョン内の行数と文字数をモードラインに表示する
;; http://d.hatena.ne.jp/sonota88/20110224/1298557375
;; (defun count-lines-and-chars ()
;;   (if mark-active
;;       (format "%d lines,%d chars"
;; 	      (count-lines (region-beginning) (region-end))
;; 	      (- (region-end) (region-beginning)))
;;     ""))
;; (add-to-list 'default-mode-line-format
;; 	     '(:eval (count-line-and-chars)))

;; テーマ
;; (when (require 'color-theme nil t)
;;   (color-theme-initialize))

;; 現在行のハイライト
;; (defface my-hl-line-face
;;   ;; 背景がdrakならば背景色を紺に
;;   '((((class color) (background dark))
;;      (:background "NavyBlue" t))
;;     ;; 背景がlightならば背景色を緑に
;;     (((class color) (background light))
;;      (:background "LightGoldenrodYellow" t))
;;     (t (:bold t)))
;;   "hl-line's my face")
;; (setq hl-line-face 'my-hl-line-face)
;; (global-hl-line-mode t)

;;; -----------------------------------------------------------------------------
;;; 拡張機能

;;; auto-install
(when (require 'auto-install nil t)
  ;; auto-installのインストールディレクトリ
  (setq auto-install-directory "~/.emacs.d/elisp")
  ;; EmacsWikiに登録されているelispの名前を更新する
  (auto-install-update-emacswiki-package-name t)
  ;; 必要であればプロキシの設定を行う
  ;; (setq url-proxy-services '(("http" . "localhost:9999")))
  ;; install-elisp互換設定
  (auto-install-compatibility-setup))

;;; redo+
;; (install-elisp "http://www.emacswiki.org/emacs/download/redo+.el")
(when (require 'redo+ nil t)
  ;; C-. にリドゥを割り当てる
  (define-key global-map (kbd "C-.") 'redo))

;;; Anything
;; (auto-install-batch "anything")
(when (require 'anything nil t)
  (setq
   ;; 候補を表示するまでの時間 デフォルト0.5
   anything-idle-delay 0.3
   ;; タイプして再描画するまでの時間 デフォルト0.1
   anything-input-idle-delay 0.2
   ;; 候補の最大表示数 デフォルト50
   anything-candidate-number-limit 100
   ;; 候補が多い時に体感速度を早くする
   anything-quick-update t
   ;; 候補選択ショートカットをアルファベットに
   anything-enable-shortcuts 'alphabet)

  (when (require 'anything-config nil t)
    ;; root権限でアクションを実行するときのコマンド デフォルトはsu
    (setq anything-su-or-sudo "sudo"))

  (require 'anything-match-plugin nil t)

  (when (and (executable-find "cmigemo")
	     (require 'migemo nil t))
    (require 'anything-migemo nil t))

  (when (require 'anything-complete nil t)
    ;; lispシンボルの補完候補の再検索時間
    (anything-lisp-complete-symbol-set-timer 150))

  (require 'anything-show-completion nil t)

  (when (require 'auto-install nil t)
    (require 'anything-auto-install nil t))

  (when (require 'descbinds-anything nil t)
    ;; describe-bindingsをAnyghingに置き換える
    (descbinds-anything-install)))
