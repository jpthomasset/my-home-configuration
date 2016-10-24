(require 'package)
(setq
 package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                    ("org" . "http://orgmode.org/elpa/")
                    ("melpa" . "http://melpa.org/packages/")
                    ("melpa-stable" . "http://stable.melpa.org/packages/")))
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(tool-bar-mode 0) 
(menu-bar-mode 0)
(toggle-frame-fullscreen)
(scroll-bar-mode -1)
(fset `yes-or-no-p `y-or-n-p)
(load-theme 'monokai t)
; Set font size in 1/10pt
(set-face-attribute 'default nil :height 100)
; Set backup dir to ~/.saves
(setq backup-directory-alist `(("." . "~/.saves")))
; Open url underneath cursor `C-xg` for `go`
(global-set-key "\C-xg" 'browse-url-at-point)

; Save session
(desktop-save-mode 1)

;(require 'printing)				; Print options
;(setq pr-ps-name       'MPC2050)
;(setq pr-ps-printer-alist     '((MPC2050 "lpr" nil "-P" "MPC2050")))
;(pr-update-menus t)

(add-to-list 'load-path '"~/.emacs.d/load-path")

; Focus window on open new file from window manager
(defun px-raise-frame-and-give-focus ()
  (when window-system
    (raise-frame)
    (x-focus-frame (selected-frame))
    (set-mouse-pixel-position (selected-frame) 4 4)
    ))

(require 'server)
(unless (server-running-p)
  (server-start)
  (add-hook 'server-switch-hook 'px-raise-frame-and-give-focus))




					; ENSIME (scala)
(use-package ensime
  :ensure t)
(setq ensime-startup-snapshot-notification nil)

(require 'helm-config)
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(global-set-key (kbd "C-x C-b") #'helm-buffers-list)
(setq helm-ls-git-fuzzy-match t)
(helm-mode 1)

(require 'helm-ls-git)
(global-set-key (kbd "C-x C-d") 'helm-browse-project)


(require 'neotree)
(global-set-key [f8] 'neotree-toggle)

;(require 'shackle)
;(setq shackle-rules '(("\\`\\*helm.*?\\*\\'" :regexp t :align t :ratio 0.3)))
;(shackle-mode)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(helm-ls-git-show-abs-or-relative (quote relative))
 '(package-selected-packages
   (quote
    (magit use-package shackle scala-mode2 neotree monokai-theme markdown-mode js2-mode jdee helm-ls-git ensime ac-php))))

; Javascript settings
(setq js-indent-level 4)
(setq-default indent-tabs-mode nil)

(use-package smartparens
  :diminish smartparens-mode
  :commands
  smartparens-strict-mode
  smartparens-mode
  sp-restrict-to-pairs-interactive
  sp-local-pair
  :init
  (setq sp-interactive-dwim t)
  :config
  (require 'smartparens-config)
  (sp-use-smartparens-bindings)

  (sp-pair "(" ")" :wrap "C-(") ;; how do people live without this?
  (sp-pair "[" "]" :wrap "s-[") ;; C-[ sends ESC
  (sp-pair "{" "}" :wrap "C-{")

  ;; WORKAROUND https://github.com/Fuco1/smartparens/issues/543
  (bind-key "C-<left>" nil smartparens-mode-map)
  (bind-key "C-<right>" nil smartparens-mode-map)

  (bind-key "s-<delete>" 'sp-kill-sexp smartparens-mode-map)
  (bind-key "s-<backspace>" 'sp-backward-kill-sexp smartparens-mode-map))

(use-package magit)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
