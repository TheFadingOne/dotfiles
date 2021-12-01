;; Melpa stuff
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Install use-package if not intsalled
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; set meta key to windows button
(setq x-super-keysym 'meta)

;; slime config
(windmove-default-keybindings)
(setq inferior-lisp-program "/usr/bin/sbcl")
(add-to-list 'load-path "/usr/share/emacs/site-lisp/slime")
(use-package slime
  :ensure t)

(use-package slime-repl-ansi-color
  :ensure t
  :hook (slime-repl-mode . slime-repl-ansi-color-mode))

(slime-setup)

;; TODO initialization
(load-theme 'manoj-dark t)

;; lisp mode
(electric-pair-mode)
(show-paren-mode)

;; general stuff

;; indentation
(setq custom-tab-width 8)
(setq-default tab-width 8)

(setq-default c-default-style "ellementel"
              c-basic-offset 8
              indent-tabs-mode nil)

(defun disable-tabs () (setq indent-tabs-mode nil))
(defun enable-tabs ()
  (local-set-key (kbd "TAB") 'tab-to-tab-stop)
  (setq indent-tabs-mode t)
  (setq tab-width custom-tab-width))

;;(add-hook 'prog-mode-hook 'enable-tabs)
(add-hook 'lisp-mode-hook 'disable-tabs)
(add-hook 'emacs-lisp-mode-hook 'disable-tabs)

(setq-default electric-indent-inhibit t)
(setq backward-delete-char-untabify-method 'hungry)

(setq whitespace-style '(face tabs tab-mark trailling))
(custom-set-faces
 '(whitespace-tab ((t (:foreground "#636363")))))
(setq whitespace-display-mappings
      '((tab-mark 9 [124 9] [92 9])))
(global-whitespace-mode)

;; line numbers
(global-display-line-numbers-mode)
(setq-default display-line-numbers-type 'relative)

;; (defvaralias 'c-basic-offset 'tab-width)

;; Install packages
(use-package rust-mode
  :ensure t)

;; (use-package d-mode
;;   :ensure t)

(use-package cider
  :ensure t)

(use-package clojure-mode
  :ensure t)

(use-package company
  :ensure t)

;; Lsp stuff
(use-package lsp-java
  :ensure t
  :hook (java-mode . lsp))

(use-package lsp-mode
  :ensure t
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook (
	 ;; (lisp-mode . lsp)
	 (c-mode . lsp)
	 (c++-mode . lsp)
	 (d-mode . lsp)
	 (rust-mode . lsp)
	 (clojure-mode . lsp)
	 (lsp-mode . lsp-enable-which-key-integration)) ; do I need that?
  :commands lsp)

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

(use-package helm-lsp
;;  :ensure t
  :commands helm-lsp-workspace-symbol)

(use-package lsp-ivy
  :ensure t
  :commands lsp-ivy-workspace-symbol)

(use-package lsp-treemacs
;;  :ensure t
  :commands lsp-treemacs-error-list)

;; TODO dap-mode

(use-package which-key
  :ensure t
  :config
  (which-key-mode))
