(eval-when-compile
  (require 'use-package))

;; set meta key to windows button
(setq x-super-keysym 'meta)

;; slime config
(windmove-default-keybindings)
(setq inferior-lisp-program "/usr/bin/sbcl")
(add-to-list 'load-path "/usr/share/emacs/site-lisp/slime")
(require 'slime)
(slime-setup)

;; TODO initialization
(load-theme 'manoj-dark t)

;; lisp mode
(electric-pair-mode)
(show-paren-mode)

;; general stuff
(global-display-line-numbers-mode)
(setq display-line-numbers 'relative)

;; Melpa stuff
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Lsp stuff
;; (setq lsp-keymap-prefix "s-l")

;; (require 'lsp-mode)
;; (add-hook 'lisp-mode-hook #'lsp)
;; (add-hook 'rust-mode-hook #'lsp)
(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook (
	 ;; (lisp-mode . lsp)
	 (rust-mode . lsp)
	 (lsp-mode . lsp-enable-which-key-integration)) ; do I need that?
  :commands lsp)

(use-package lsp-ui :commands lsp-ui-mode)

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
