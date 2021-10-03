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
(slime-setup)

;; TODO initialization
(load-theme 'manoj-dark t)

;; lisp mode
(electric-pair-mode)
(show-paren-mode)

;; general stuff
(global-display-line-numbers-mode)
(setq-default display-line-numbers-type 'relative)

;; Install packages
(use-package rust-mode
  :ensure t)

(use-package cider
  :ensure t)

(use-package clojure-mode
  :ensure t)

(use-package company
  :ensure t)

;; Lsp stuff
(use-package lsp-mode
  :ensure t
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook (
	 ;; (lisp-mode . lsp)
	 (rust-mode . lsp)
	 (clojure-mode . lsp)
	 (lsp-mode . lsp-enable-which-key-integration)) ; do I need that?
  :commands lsp)

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

;; Autocreated stuff
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(cider clojure-mode rust-mode use-package company lsp-ui lsp-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
