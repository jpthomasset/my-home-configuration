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
;(toggle-frame-fullscreen)
; Borderless frame (window)
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
                                        ; Alternate desktop file when running in terminal
(unless (window-system)
  (setq desktop-base-file-name ".emacs-cli-desktop")
  (setq desktop-base-lock-name ".emacs-cli-desktop.lock"))
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
(global-set-key (kbd "C-:") 'comment-or-uncomment-region)
(global-set-key (kbd "s-d") 'helm-semantic-or-imenu)
(global-set-key (kbd "s-r") 'helm-resume)
(global-set-key (kbd "C-s-o") 'helm-occur)
(setq helm-ls-git-fuzzy-match t)
(helm-mode 1)

; see https://github.com/emacs-helm/helm/wiki/FAQ#arrow-keys-behavior-have-changed
(define-key helm-map (kbd "<left>") 'helm-previous-source)
(define-key helm-map (kbd "<right>") 'helm-next-source)
(customize-set-variable 'helm-ff-lynx-style-map t)

;; **** BASH CONFIG ***
(add-hook 'sh-mode-hook
      '(lambda() 
        (setq tab-width 4)
        (setq indent-tabs-mode t)))


;; ****** ENSIME (scala) *******
;(use-package ensime
;  :ensure t
;  :pin melpa-stable)
;(setq ensime-startup-notification nil)
;(setq ensime-search-interface 'helm)

;; ****** LSP Mode scala ******
(add-to-list 'exec-path "~/.local/share/coursier/bin" t)
(use-package scala-mode
  :interpreter
    ("scala" . scala-mode))

;; (use-package lsp-scala
;;   :load-path "~/tools/metals/"
;;   :after scala-mode
;;   :demand t
;;   :hook (scala-mode . lsp)
;;   :init (setq lsp-scala-server-command "~/tools/metals/metals-emacs"))

;; Enable sbt mode for executing sbt commands
(use-package sbt-mode
  :commands sbt-start sbt-command
  :config
  ;; WORKAROUND: https://github.com/ensime/emacs-sbt-mode/issues/31
  ;; allows using SPACE when in the minibuffer
  (substitute-key-definition
   'minibuffer-complete-word
   'self-insert-command
   minibuffer-local-completion-map)
   ;; sbt-supershell kills sbt-mode:  https://github.com/hvesalai/emacs-sbt-mode/issues/152
   (setq sbt:program-options '("-Dsbt.supershell=false"))
   )

;; Enable nice rendering of diagnostics like compile errors.
(use-package flycheck
  :init (global-flycheck-mode))

(use-package lsp-mode
  ;; Optional - enable lsp-mode automatically in scala files
  :hook  (scala-mode . lsp)
         (lsp-mode . lsp-lens-mode)
  :config (setq lsp-prefer-flymake nil))

;; Add metals backend for lsp-mode
(use-package lsp-metals
  :config (setq lsp-metals-treeview-show-when-views-received nil))

(use-package lsp-ui)

;; Add company-lsp backend for metals
(use-package company-lsp)

;; Use the Debug Adapter Protocol for running tests and debugging
(use-package posframe
  ;; Posframe is a pop-up tool that must be manually installed for dap-mode
  )
(use-package dap-mode
  :hook
  (lsp-mode . dap-mode)
  (lsp-mode . dap-ui-mode)
  )


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


; Typescript mode
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook #'setup-tide-mode)


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
;            (ensime-mode)
            (scala-mode:goto-start-of-code)))

(elpy-enable)

(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; ***** Misc *****
;; Open url underneath cursor `C-x g` for `go`
(global-set-key "\C-xg" 'browse-url-at-point)
;; Scroll one line at a time
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) 

(require 'psc-ide)

(add-hook 'purescript-mode-hook
  (lambda ()
    (psc-ide-mode)
    (company-mode)
    (flycheck-mode)
    (turn-on-purescript-indentation)))


                                        ; RUST
(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'racer-mode-hook #'company-mode)
(add-hook 'rust-mode-hook 'cargo-minor-mode)


                                        ; GO Mode
(autoload 'go-mode "go-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))
(require 'go-complete)
(add-hook 'completion-at-point-functions 'go-complete-at-point)


(require 'rust-mode)
(define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)
(setq company-tooltip-align-annotations t)

(define-coding-system-alias 'UTF-8 'utf-8)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(format-all play-routes-mode groovy-mode yaml-mode xref-js2 web-mode use-package tide terraform-doc smartparens shackle scala-mode sbt-mode purescript-mode psc-ide pdf-tools ox-reveal monokai-theme magit-popup magit lsp-ui lsp-metals less-css-mode js2-refactor htmlize helm-themes helm-projectile helm-ls-git helm-ag haskell-mode go-complete geben flymake-rust flycheck-golangci-lint find-file-in-project elpy company-terraform company-php company-lsp command-log-mode cargo ag))
 '(typescript-indent-level 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
