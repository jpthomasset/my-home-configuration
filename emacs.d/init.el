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

;; ********** Theme ************
(use-package monokai-theme
	     :ensure t)

(tool-bar-mode 0) 
(menu-bar-mode 0)
(toggle-frame-fullscreen)
(scroll-bar-mode -1)
(fset `yes-or-no-p `y-or-n-p)
(load-theme 'monokai t)
; Set font size in 1/10pt
(set-face-attribute 'default nil :height 100)

;; ******** Session & backup settings ********
;; Set backup dir to ~/.saves
(setq backup-directory-alist `(("." . "~/.saves")))
(setq make-backup-files nil)
; Save session
(desktop-save-mode 1)
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

(use-package web-mode
  :ensure t)
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

; Set web-mode for PlayFramework template file 
(setq web-mode-engines-alist
      '(("razor"    . "\\.scala.html\\'"))
)

(use-package magit
	     :ensure t)

(use-package helm
	     :ensure t)
(require 'helm-config)
(use-package helm-ls-git
  :ensure t)
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(global-set-key (kbd "C-x C-b") #'helm-buffers-list)
(global-set-key (kbd "C-x C-d") 'helm-browse-project)
(setq helm-ls-git-fuzzy-match t)
(helm-mode 1)

;; ****** ENSIME (scala) *******
(use-package ensime
  :ensure t
  :pin melpa-stable)
(setq ensime-startup-notification nil)
(setq ensime-search-interface 'helm)

(use-package yasnippet
  :diminish yas-minor-mode
  :commands yas-minor-mode
  :config (yas-reload-all))
(global-set-key (kbd "<C-tab>") 'yas-expand)

(use-package shackle
	     :ensure t)
(setq helm-display-function 'pop-to-buffer) ; make helm play nice
(setq shackle-rules '(("\\`\\*helm.*?\\*\\'" :regexp t :align t :ratio 0.4)))
(shackle-mode)

; Javascript settings
(use-package js2-mode
  :ensure t)
(setq js-indent-level 2)
(setq-default indent-tabs-mode nil)
(setq js2-basic-offset 2)
(use-package js2-refactor
  :ensure t)
(use-package xref-js2
  :ensure t)

(add-hook 'js2-mode-hook #'js2-refactor-mode)
(js2r-add-keybindings-with-prefix "C-c C-r")
(define-key js2-mode-map (kbd "C-k") #'js2r-kill)
(define-key js-mode-map (kbd "M-.") nil)
(add-hook 'js2-mode-hook (lambda ()
  (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))

(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))



(use-package smartparens
  :ensure t
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


(global-auto-revert-mode 1)
(use-package projectile
  :ensure t)
(use-package helm-projectile
  :ensure t)
(helm-projectile-on)

;; Scala mode hook
(add-hook 'scala-mode-hook
          (lambda ()
            (show-paren-mode)
            (smartparens-mode)
            (yas-minor-mode)
            (company-mode)
            (ensime-mode)
            (scala-mode:goto-start-of-code)))

;; ***** Misc *****
;; Open url underneath cursor `C-x g` for `go`
(global-set-key "\C-xg" 'browse-url-at-point)
;; Scroll one line at a time
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) 
