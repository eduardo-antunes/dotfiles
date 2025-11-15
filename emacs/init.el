; -*- lexical-binding: t; -*-

(setq ed/config-dir "~/.config/emacs/"
      ed/cache-dir  "~/.local/share/emacs/"
      ed/fixed-font "Hack 11"
      ed/var-font   "Noto Sans 12"
      ed/leader-key "C-z")

(setq scroll-margin 10
      scroll-conservatively 101  ;; rolagem suave
      split-width-threshold nil) ;; split horizontal por padrão

(setopt use-short-answers t)
(electric-pair-mode 1)
(visual-line-mode 1)

;; -----------------------------------------------------------------------------

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)
(setq use-package-always-ensure t)

;; -----------------------------------------------------------------------------

(setq user-emacs-directory (expand-file-name ed/cache-dir))
(use-package no-littering)

(setq url-history-file (no-littering-expand-var-file-name "url-history")
      custom-file (no-littering-expand-etc-file-name "custom.el"))

(setq backup-directory-alist
      `(("." . ,(no-littering-expand-var-file-name "backups/")))
      auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

;; -----------------------------------------------------------------------------

(tool-bar-mode     -1) ;; sem barra de ferramentas
(menu-bar-mode     -1) ;; sem barra de menus
(scroll-bar-mode   -1) ;; sem barra de rolagem
(blink-cursor-mode -1) ;; não gosto de cursor piscando
(set-fringe-mode    5) ;; pequenas margens

(set-face-attribute 'default nil :font ed/fixed-font)
(set-face-attribute 'fixed-pitch nil :font ed/fixed-font)
(set-face-attribute 'variable-pitch nil :font ed/var-font)

(setq display-line-numbers-type 'relative)
(defun ed/text-visual-setup ()
  "Configurações visuais em buffers de texto"
  ;; (hl-line-mode 1)
  (display-line-numbers-mode 1))

(dolist (mode '(text-mode-hook
                prog-mode-hook
                conf-mode-hook))
  (add-hook mode #'ed/text-visual-setup))

;; -----------------------------------------------------------------------------

(load-theme 'modus-vivendi :no-confirm)
(setq modus-themes-org-blocks 'gray-background
      modus-themes-italic-constructs t ;; uso generoso do itálico
      modus-themes-mixed-fonts t)      ;; fontes monoespaçadas e variáveis

(column-number-mode 1) ;; número da coluna na modeline
(use-package minions
  :custom (minions-prominent-modes '(flymake-mode))
  :config (minions-mode 1))

;; -----------------------------------------------------------------------------

(use-package which-key
  :defer 0
  :config (which-key-mode 1)
  (setq which-key-idle-delay 0.3))

(defvar-keymap ed/personal-map
  :doc "Prefixo para atalhos personalisados"
  "=" #'indent-region)
(keymap-global-set ed/leader-key ed/personal-map)

(defun ed/scroll-down ()
  "Vai para baixo metade da tela"
  (interactive)
  (scroll-down (/ (window-body-height) 2)))

(defun ed/scroll-up ()
  "Vai para cima metade da tela"
  (interactive)
  (scroll-up (/ (window-body-height) 2)))

(keymap-global-set "<escape>" #'keyboard-escape-quit)
(keymap-global-set "M-z" #'zap-up-to-char)
(keymap-global-set "C--" #'undo)
(keymap-global-set "C-v" #'ed/scroll-down)

(setq kill-whole-line t)

;; -----------------------------------------------------------------------------

(use-package orderless
  :init
  (setq completion-styles '(orderless)
        completion-category-defaults nil
        completion-category-overrides '((file (styles . (partial-completion))))))

(defun ed/minibuffer-del (arg)
  "Se o conteúdo do minibuffer for um caminho, apaga até a pasta pai do arquivo,
    do contrário, apaga normalmente (i.e. um caractere só)"
  ;; Peguei isso emprestado da configuração de um amigo
  (interactive "p")
  (if minibuffer-completing-file-name
      (if (string-match-p "/." (minibuffer-contents))
          (zap-up-to-char (- arg) ?/)
        (delete-minibuffer-contents))
    (backward-delete-char arg)))

(use-package vertico
  :bind (:map vertico-map
              ("C-j" . vertico-next)
              ("C-k" . vertico-previous)
              :map minibuffer-local-map
              ("M-h" . backward-kill-word)
              ("<backspace>" . ed/minibuffer-del))
  :init
  (setq vertico-cycle t)
  (vertico-mode))
(use-package marginalia :init (marginalia-mode))

(use-package corfu
  :demand t
  :custom
  (corfu-cycle t)
  :init
  (global-corfu-mode 1)
  :config
  (keymap-unset corfu-map "RET")
  (setq tab-always-indent 'complete)
  (setq completion-cycle-threshold 3))

;; -----------------------------------------------------------------------------

(use-package dired
  :ensure nil
  :config
  (setq dired-listing-switches "-lAh --group-directories-first --sort=extension"
        delete-by-moving-to-trash t
        dired-kill-when-opening-new-dired-buffer t))

(use-package diredfl
  :after dired
  :hook (dired-mode . diredfl-mode))

(use-package vterm
  :config
  (keymap-set ed/personal-map "T" #'vterm)
  (keymap-set ed/personal-map "t" #'vterm-other-window))

(use-package magit
  :config
  (keymap-set ed/personal-map "g" #'magit-status)
  (keymap-set project-prefix-map "g" #'magit-project-status))

;; -----------------------------------------------------------------------------

(setq c-ts-mode-indent-offset 4)
(global-set-key (kbd "RET") #'newline-and-indent)

(require 'treesit)
(customize-set-variable 'treesit-font-lock-level 3)
(setq treesit-language-source-alist
      '((c "https://github.com/tree-sitter/tree-sitter-c" "v0.20.1")
	(cpp "https://github.com/tree-sitter/tree-sitter-cpp" "v0.23.4")))

(setq major-mode-remap-alist
      '((c-mode . c-ts-mode)))

(push "~/.local/bin" exec-path) ;; alguns servidores LSP estão aqui
(use-package eglot
  :ensure nil
  :custom
  (eglot-ignored-server-capabilities '(:documentOnTypeFormattingProvider)))

(use-package compile
 :hook (compilation-filter . ansi-color-compilation-filter)
 :custom (ansi-color-bold-is-bright 't))
(setq compilation-scroll-output t)

(use-package project
  :ensure nil
  :config
  (setopt xref-search-program 'ripgrep))

;; -----------------------------------------------------------------------------

(setq gc-cons-threshold (* 20 1000 1000))
