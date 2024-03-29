;; bootstrapping straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'setup)
(require 'setup)
(setup-define :straight
	      (lambda (recipe)
		`(unless (straight-use-package ', recipe)
		   ,(setup-quit)))
	      :documentation
	      "install package with straight-use-package"
	      :repeatable t
	      :shorthand (lambda (sexp)
			   (let ((recipe (cadr sexp)))
			     (if (consp recipe)
				 (car recipe)
			       (recipe)))))


(defun meow-setup ()
  "setup function for meow-mode"
  (meow-motion-overwrite-define-key
   '("j" . meow-next)
   '("k" . meow-prev)
   '("<escape>" . ignore))
  (meow-leader-define-key
   ;; SPC j/k will run the original command in MOTION state.
   '("j" . "H-j")
   '("k" . "H-k")
   '("p" . "C-x p") ;; for project.el
   '("s" . "M-g")   ;; for goto map
   ;; Use SPC (0-9) for digit arguments.
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("/" . meow-keypad-describe-key)
   '("?" . meow-cheatsheet))
  
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("d" . meow-delete)
   '("D" . meow-backward-delete)
   '("e" . meow-next-word)
   '("E" . meow-next-symbol)
   '("f" . meow-find)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-next)
   '("J" . meow-next-expand)
   '("v" . meow-right-expand)
   '("k" . meow-prev)
   '("K" . meow-prev-expand)
   '("l" . meow-right)
   '("L" . meow-right-expand)
   '("m" . meow-join)
   '("n" . meow-search)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-yank)
   '("q" . meow-quit)
   '("Q" . meow-goto-line)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   '("s" . meow-kill)
   '("t" . meow-till)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("/" . meow-visit)
   '("w" . meow-mark-word)
   '("W" . meow-mark-symbol)
   '("x" . meow-line)
   '(":" . meow-goto-line)
   '("y" . meow-save)
   '("?" . vundo)
   '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("<escape>" . ignore)))
  

(setup meow-mode
  (:straight meow)
  (:option meow-cheatsheet-layout 'meow-cheatsheet-layout-qwerty)
  (require 'meow)
  (meow-setup)
  (meow-global-mode 1))


(setup cus-start
  (:option
   ;; i18n settings
   prefer-coding-system                  'utf-8
   
   ;; disable external IME
   pgtk-use-im-context                   nil
   pgtk-use-im-context-on-new-connection nil


   ;; for better performance
   inhibit-compacting-font-caches        t
   read-process-output-max               (* 1024 1024) 

   ;; remove visual clutters
   tool-bar-mode                         nil
   menu-bar-mode                         nil
   scroll-bar-mode                       nil

   ;; improve ux
   electric-pair-mode                    t
   make-backup-files                     nil
   savehist-mode                         t
   global-auto-revert-mode               t
   enable-recursive-minibuffers          t)

  (:with-mode prog-mode
    (:hook display-line-numbers-mode
	   display-fill-column-indicator-mode)))


(fset 'yes-or-no-p 'y-or-n-p)

(add-to-list 'default-frame-alist '(font . "monospace-13"))
(set-face-attribute 'default nil
		    :family "monospace-13")

(set-frame-font "monospace-13" nil t)

(setup corfu
  (:straight corfu)
  
  (:option
   completion-cycle-threshold 3
   tab-always-indent 'complete
   corfu-cycle t
   corfu-auto t
   corfu-auto-prefix 8
   corfu-auto-delay 2)

  (:bind
    "TAB"    #'corfu-next
    "M-j"    #'corfu-next
    "M-k"    #'corfu-previous
    "M-SPC"  #'corfu-insert-separator)
  (global-corfu-mode))

(setup orderless
  (:straight orderless)
  (:option completion-styles '(orderless basic)
      completion-category-overrides
      '((file (styles basic partial-completion)))))


(setup popper-mode
  (:straight popper)
  (require 'project)
  (:global
   "M-`" popper-toggle
   "M-c" popper-cycle
   "M-t" popper-toggle-type)
  
  (:option
   popper-display-control 't
   popper-group-function #'popper-group-by-project
   popper-reference-buffers '("^\\*eshell.*\\*$" eshell-mode
			      "^\\*shell.*\\*$" shell-mode
			      "^\\*vterm.*\\*$" vterm-mode
			      compilation-mode
			      comint-mode
			      "Output\\*$"
			      "\\*Messages\\*"
			      smudge-mode
			      help-mode
			      "\\*Async Shell Command\\*"))
  (popper-mode +1)
  (popper-echo-mode +1))

(setup eglot
  (:straight markdown-mode)
  (:bind-into eglot-mode-map
    "C-c C-r" #'eglot-rename
    "C-c C-o" #'eglot-code-action-organize-imports
    "C-c C-h" #'eldoc)
  (:option
   eglot-extend-to-xref 't
   eglot-events-buffer-size '0 ;; disable logging for speedup
   eglot-autoshutdown 't
   ))


(setup vundo
  (:straight vundo)
  (:bind
    "h" #'vundo-backward
    "j" #'vundo-next
    "k" #'vundo-previous
    "l" #'vundo-forward))

(setup vertico
  (:straight vertico marginalia)
  (:option 
   vertico-mode           t
   vertico-multiform-mode t
   vertico-cycle          t
   
   vertico-multiform-categories '((embark-keybinding grid)))
  
  (:option marginalia-mode t)
  (:bind-into minibuffer-local-map
    "M-j"   #'next-line ;; for vertico
    "M-k"   #'previous-line
    ;; ido-like directory changing
    "RET"   #'vertico-directory-enter
    "DEL"   #'vertico-directory-delete-char
    "M-DEL" #'vertico-directory-delete-word)
  
  (:with-mode rfn-eshadow-update-overlay-hook
    (:hook vertico-directory-tidy)))

(setup mood-line
  (:straight mood-line)
  (:option
   mood-line-mode t))

(setq tramp-default-method "ssh")

(defun with-sudo-prefix (filename) (concat "/sudo::" filename))

(defun sudo-find-file (file)
  "Open FILE as root."
  (interactive "FOpen file as root: ")
  (when (file-writable-p file)
    (user-error "File is user writeable, aborting sudo"))
  (find-file (if (file-remote-p file)
                 (concat "/" (file-remote-p file 'method) ":"
                         (file-remote-p file 'user) "@" (file-remote-p file 'host)
                         "|sudo:root@"
                         (file-remote-p file 'host) ":" (file-remote-p file 'localname))
               (concat "/sudo:root@localhost:" file))))

(defun sudo-reopen-file ()
  "Reopen file as root by prefixing its name with sudo-tramp-prefix and by clearing buffer-read-only"
  (interactive)
  (let* 
      ((file-name (expand-file-name buffer-file-name))
       (sudo-name (with-sudo-prefix file-name)))
    (progn           
      (setq buffer-file-name sudo-name)
      (rename-buffer sudo-name)
      (setq buffer-read-only nil)
      (message (concat "Set file name to " sudo-name)))))

(setup super-save-mode
  (:straight super-save)
  (:option super-save-mode t))


(defun activate-input-method-wrapper ()
  (let ((prev-input-method current-input-method))
    (setq-local current-input-method nil)
    (activate-input-method prev-input-method)))

(defun deactivate-input-method-wrapper ()
  (let ((prev-input-method current-input-method)
	(prev-input-method-title current-input-method-title))

    (deactivate-input-method)
    (setq-local current-input-method prev-input-method
		current-input-method-title prev-input-method-title)))

(defun input-method-activate-guard ()
  (when (not (or (meow-insert-mode-p)
		 (meow-motion-mode-p)
		 (minibufferp)))
    (deactivate-input-method-wrapper)))

(add-hook 'meow-insert-exit-hook 'deactivate-input-method-wrapper)
(add-hook 'meow-insert-enter-hook 'activate-input-method-wrapper)
(add-hook 'input-method-activate-hook 'input-method-activate-guard)

(setq default-input-method "korean-hangul")

(global-set-key (kbd "<Hangul>") 'toggle-input-method)

(setup direnv-mode
  (:straight direnv)
  (direnv-mode))

(setup nix-mode
  (:straight nix-mode)
  (add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode)))

(setup doom-themes
  (:straight doom-themes)
  (load-theme 'doom-one-light t))

(setup dashboard
  (:straight dashboard)
  (dashboard-setup-startup-hook)
  (:option
   ;; for emacsclient
   initial-buffer-choice (lambda () (get-buffer-create "*dashboard*"))
   ))


(setup nerd-icons-mode
  (:straight nerd-icons
	     nerd-icons-dired
	     nerd-icons-completion
	     nerd-icons-ibuffer)
  
  (:with-mode dired-mode
    (:hook nerd-icons-dired-mode))
  
  (:with-mode marginalia-mode
    (:hook nerd-icons-completion-marginalia-setup))
  
  (:with-mode ibuffer-mode
    (:hook nerd-icons-ibuffer-mode)))

(setup dired
  (:straight dirvish)
  (:bind
    "a" #'dirvish-quick-access
    "y" #'dirvish-yank-menu
    "l" #'dired-find-file
    "h" #'dired-up-directory)
  
  (:option
   dirvish-quick-access-entries
   '(("h" "~/"                     "Home")
     ("d" "~/Downloads"            "Downloads")
     ("f" "~/Documents"            "Documents")
     ("c" "~/.config"              "config")
     ("n" "~/.config/home-manager" "Home manager")))
  
  (dirvish-override-dired-mode))

(setup recentf-mode
  (:option
   recentf-auto-cleanup    'never ;; for tramp
   recentf-max-saved-items 25
   recentf-mode            t))


;; TODO : follow url
(setup embark
  (:straight embark embark-consult)
  (:option
   prefix-help-command #'embark-prefix-help-command
   embark-indicators '(embark-minimal-indicator)
   embark-prompter #'embark-completing-read-prompter)
  
  (:hook
   embark-collect-mode consult-preview-at-point-mode)

  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none))))
  (:global
   "M-e" 'embark-act)
  (:bind-into embark-file-map
    "S" 'sudo-find-file))

(setup consult-mode
  (:straight consult)
  (:global
    "C-x C-b" #'consult-buffer
    "C-x b"   #'ibuffer
    "C-x pb"  #'consult-project-buffer

    "M-g l"   #'consult-line
    "M-g r"   #'consult-grep
    
    "M-g f"   #'consult-flymake
    "M-g h"   #'consult-imenu))

(setup epg ;; for pinentry setting
  (:option epg-pinentry-mode 'loopback))

(setup which-key ;; 근데 굳이 필요없을지도
  (:straight which-key)
  (:option
   which-key-popup-type 'minibuffer
   which-key-mode       t))

(setup magit
  (:straight magit)) ;; 그냥 좋음

(setup org
  (:bind-into org-mode-map
   "M-n" #'org-metadown
   "M-p" #'org-metaup
   "M-l" #'org-metaright
   "M-h" #'org-metaleft
   ))



(setup rust-mode
  (:straight rust-mode)
  (add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode)))

(setup tuareg
  (:straight tuareg utop))

;; need more settings
(setup ace-window
  (:straight ace-window)
  (:global
   "M-o" 'ace-window)
  (:option
   aw-keys '(?h ?j ?k ?l)))
