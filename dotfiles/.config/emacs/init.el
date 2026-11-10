;;; init.el --- Personal Emacs configuration -*- lexical-binding: t; -*-

;; Identity and files ---------------------------------------------------------
(setq user-full-name "Joao"
      inhibit-startup-screen t
      initial-scratch-message nil
      ring-bell-function #'ignore
      use-short-answers t
      confirm-kill-emacs #'y-or-n-p
      custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror 'nomessage)

(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8-unix)
(setq-default indent-tabs-mode nil
              tab-width 4
              fill-column 100)

;; Interface ------------------------------------------------------------------
(set-face-attribute 'default nil
                    :family "JetBrainsMono Nerd Font"
                    :height 120)
(set-face-attribute 'fixed-pitch nil
                    :family "JetBrainsMono Nerd Font"
                    :height 1.0)
(set-face-attribute 'variable-pitch nil
                    :family "sans-serif"
                    :height 1.0)

(column-number-mode 1)
(global-hl-line-mode 1)
(global-auto-revert-mode 1)
(electric-pair-mode 1)
(delete-selection-mode 1)
(pixel-scroll-precision-mode 1)
(setq scroll-conservatively 101
      mouse-wheel-progressive-speed nil
      sentence-end-double-space nil)

(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'text-mode-hook #'display-line-numbers-mode)
(add-hook 'prog-mode-hook
          (lambda ()
            (setq-local show-trailing-whitespace t)))

;; Backups, autosaves and history --------------------------------------------
(let ((cache-dir (expand-file-name "emacs/" (or (getenv "XDG_CACHE_HOME")
                                                 "~/.cache/"))))
  (make-directory cache-dir t)
  (setq backup-directory-alist `(("." . ,(expand-file-name "backups/" cache-dir)))
        auto-save-file-name-transforms `((".*" ,(expand-file-name "autosaves/" cache-dir) t))
        auto-save-list-file-prefix (expand-file-name "autosaves/sessions-" cache-dir))
  (make-directory (expand-file-name "backups/" cache-dir) t)
  (make-directory (expand-file-name "autosaves/" cache-dir) t))

(savehist-mode 1)
(save-place-mode 1)
(recentf-mode 1)
(setq history-length 500
      recentf-max-saved-items 200
      create-lockfiles nil
      make-backup-files t
      version-control t
      kept-new-versions 5
      kept-old-versions 2
      delete-old-versions t)

;; Packages -------------------------------------------------------------------
(require 'package)
(setq package-archives '(("gnu"    . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("melpa"  . "https://melpa.org/packages/")))
(package-initialize)

(require 'use-package)
(setq use-package-always-ensure t
      use-package-expand-minimally t)

(use-package vertico
  :init
  (vertico-mode 1))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :init
  (marginalia-mode 1))

(use-package consult
  :bind (("C-x b" . consult-buffer)
         ("C-x p b" . consult-project-buffer)
         ("M-g g" . consult-goto-line)
         ("M-s r" . consult-ripgrep)
         ("M-y" . consult-yank-pop)))

(use-package which-key
  :init
  (which-key-mode 1)
  :custom
  (which-key-idle-delay 0.5))

(use-package treemacs
  :bind (("<f8>" . treemacs))
  :custom
  (treemacs-width 32)
  (treemacs-position 'left)
  (treemacs-is-never-other-window t)
  (treemacs-follow-after-init t)
  (treemacs-file-event-delay 2000)
  (treemacs-silent-filewatch t)
  :config
  (treemacs-follow-mode 1)
  (treemacs-filewatch-mode 1)
  (add-hook 'emacs-startup-hook #'treemacs))

(use-package treemacs-nerd-icons
  :after treemacs
  :config
  (treemacs-load-theme "nerd-icons"))

;; Native project integration.
(setq project-switch-commands
      '((project-find-file "Find file")
        (consult-ripgrep "Ripgrep")
        (project-dired "Dired")
        (project-eshell "Eshell")))

;; Dynamic Matugen theme ------------------------------------------------------
(let ((theme-file (expand-file-name "matugen-theme.el" user-emacs-directory)))
  (if (file-readable-p theme-file)
      (progn
        (load theme-file nil 'nomessage)
        (load-theme 'matugen t))
    (load-theme 'modus-vivendi t)))

;; Allow Matugen to refresh the theme in running frames through emacsclient.
(require 'server)
(unless (server-running-p)
  (server-start))

(provide 'init)
;;; init.el ends here
