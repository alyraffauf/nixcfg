; Load catppuccin theme.
;(load-theme 'catppuccin :no-confirm)
;(setq catppuccin-flavor 'mocha) ;; or 'latte, 'macchiato, or 'mocha
;(catppuccin-reload)

;(defun on-after-init ()
;  (unless (display-graphic-p (selected-frame))
;    (set-face-background 'default "unspecified-bg" (selected-frame))))

;(add-hook 'window-setup-hook 'on-after-init)

; 4 spaces > tabs.
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

; xterm mouse mode
(xterm-mouse-mode 1)

; Enable line numbers
(global-display-line-numbers-mode 1)
(global-hl-line-mode t)

; Enable mouse scrolling
(global-set-key (kbd "<mouse-4>") 'previous-line)
(global-set-key (kbd "<mouse-5>") 'next-line)

; Enable tabs
(tab-bar-mode 1)
(setq tab-bar-show 1)
(setq tab-bar-new-tab-choice "*dashboard*")

; Enable treemacs
(add-hook 'emacs-startup-hook 'treemacs)
(treemacs-load-theme "Default")
(setq treemacs-width 20)
(treemacs-resize-icons 16) ; Adjust the icon size according to your preference
(setq treemacs-follow-mode t) ; Enable follow mode
(setq treemacs-filewatch-mode t) ; Enable file watch mode
(setq treemacs-fringe-indicator-mode t) ; Enable fringe indicator mode
(setq treemacs-git-mode 'simple) ; Set git mode to simple
(setq treemacs-git-integration t) ; Enable git integration
(setq treemacs-show-hidden-files t) ; Show hidden files
(setq treemacs-icons-dired-mode t) ; Use icons in dired buffers
(setq treemacs-set-scope-type 'Tabs)

; Enable column 80 line for coding
(setq-default fill-column 80)
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)

(make-directory "~/Sync/org-roam")
(setq org-directory "~/Sync/org-roam/")
(setq org-roam-directory (file-truename "~/Sync/org-roam"))
(setq org-roam-dailies-directory "journal/")
(org-roam-db-autosync-mode)
