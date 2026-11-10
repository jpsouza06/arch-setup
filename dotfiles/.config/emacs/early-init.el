;;; early-init.el --- Early startup settings -*- lexical-binding: t; -*-

;; Reduce visual noise before the first frame is drawn.
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)

;; Avoid the bright default frame while the Matugen theme is loading.
(add-to-list 'default-frame-alist '(background-color . "#0f1416"))
(add-to-list 'default-frame-alist '(foreground-color . "#dee3e6"))
(add-to-list 'default-frame-alist '(font . "JetBrainsMono Nerd Font-12"))
(setq frame-inhibit-implied-resize t)

;; Defer garbage collection during startup, then restore sane values.
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 32 1024 1024)
                  gc-cons-percentage 0.1)))

;; Keep package activation available to the main configuration.
(setq package-enable-at-startup t)

(provide 'early-init)
;;; early-init.el ends here
