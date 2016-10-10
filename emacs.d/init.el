(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade.ferrier.me.uk/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(package-initialize)
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
(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
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
 '(helm-ls-git-show-abs-or-relative (quote relative))
 )
