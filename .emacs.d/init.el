;; source :: http://www.emacswiki.org/emacs/start.el

(defun osx ()
  (eq system-type 'darwin))

;; (when (osx)
;;   (set-default-font "-*-Source Code Pro-light-normal-normal-*-20-*-*-*-m-0-iso10646-1")
;;   ;; (add-to-list 'default-frame-alist '(font . "Source Code Pro-22"))
;;   (add-to-list 'default-frame-alist '(font . "Source Code Pro-iso10646-0-light-20"))
;;   ;; (set-fontset-font "fontset-default" nil
;;   ;;                   (font-spec :size 20 :name "Symbola:"))
;;   )

(when (osx)
  (set-face-attribute 'default nil :family "Source Code Pro")
  (set-face-attribute 'default nil :height 200)
  (set-face-attribute 'default nil :weight 'light))

(provide 'start)
(require 'start) ;; Ensure this file is loaded before compile it.

;; end of source

(load "server")
(unless (server-running-p) (server-start))

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(defun str-exists ()
  (let ((path "/str/development/projects/open-source/"))
    (if (file-exists-p path) t nil)))

(if (osx)
    (progn
      (setq open-source-path "/Users/atykhonov/.ghq/")
      (setq open-source-elisp "/Users/atykhonov/elisp/"))
  (progn
    (setq open-source-path "/str/development/projects/open-source/.ghq/")
    (setq open-source-elisp "/str/development/projects/open-source/elisp/")))

(defun oo-elisp-path (path)
  (concat open-source-elisp path))

(defun oo-ghq-path (path)
  (concat open-source-path path))

(load-file (oo-elisp-path "ef.el/ef.el"))

(defmacro defhook (body)
  `(lambda ()
     (interactive)
     (,@body)))

(defun turn-on-mode (mode)
  (interactive)
  (funcall mode))

(require 'package)

(setq package-archives '(("org"          . "http://orgmode.org/elpa/")
                         ("gnu"          . "http://elpa.gnu.org/packages/")
                         ("elpy"         . "http://jorgenschaefer.github.io/packages/")
                         ("melpa-stable" . "http://melpa-stable.milkbox.net/packages/")
                         ("melpa"        . "http://melpa.milkbox.net/packages/")
                         ("marmalade"    . "http://marmalade-repo.org/packages/")))

(package-initialize)


(when (not (osx))
  (add-to-list 'load-path (oo-elisp-path "bisect.el/"))
  (require 'bisect)
  (bisect-load))

(let ((sensitive-file "~/.emacs.d/sensitive.el"))
  (when (file-readable-p sensitive-file)
    (load-file sensitive-file)))

;; (require 'test-bisect)



(require 'cask "~/.cask/cask.el")
(cask-initialize)

(require 'cl)

;; from https://gist.github.com/gnuvince/1869094
;; General settings
(setq user-full-name "Andrey Tykhonov"
      user-mail-address "atykhonov@gmail.com"
      inhibit-startup-message t
      major-mode 'fundamental-mode
      next-line-add-newlines nil
      font-lock-maximum-decoration nil
      require-final-newline t
      truncate-partial-width-windows nil
      shift-select-mode nil
      echo-keystrokes 0.1
      x-select-enable-clipboard t
      mouse-yank-at-point t
      custom-unlispify-tag-names nil
      ring-bell-function '(lambda ()))

(menu-bar-mode -1)
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;; highlight current line
(global-hl-line-mode t) ;; To enable
(set-face-background 'hl-line "gray18") ;; change with the color that you like
;; for a list of colors: http://raebear.net/comp/emacscolors.html
(setq inhibit-splash-screen t)
(transient-mark-mode 1)
(global-font-lock-mode 1)
(setq jit-lock-defer-time 0.05)

;; (require 'demi-appearance)

(display-battery-mode)

;; Sources:
;;; http://www.reddit.com/r/emacs/comments/2tqdi7/mode_line_battery_indicator_with_unicode_character/
;;; https://gist.github.com/jordonbiondo/220c41bc33567cb0a0be

;; (defun battery-indicator-string ()
;;   (let* ((bat (funcall battery-status-function))
;;          (index (cl-position-if (lambda (e) (> bat e)) '(87 75 62 50 37 25 12 7 -1)))
;;          (symbol (nth index '("█" "▇" "▆" "▅" "▄" "▃" "▂" "▁" "!")))
;;          (color (nth index (mapcar (lambda (c) (apply 'color-rgb-to-hex c)) (color-gradient '(.3 1 .2) '(1 .2 .1) 9)))))
;;     (propertize symbol 'face (list :foreground color :box (if (<= bat 7) color nil)))))

;; (mapcar (lambda (c) (apply 'color-rgb-to-hex c)) (color-gradient '(.4 .9 .2) '(1 .2 .1) 9))
;; ("#75d330" "#84c12d" "#93af2b" "#a39e28" "#b28c26" "#c17a23" "#d16821" "#e0561e" "#ef441c")

;; (add-to-list 'mode-line-format '(:eval battery-indicator-string))

;; (require 'demi-battery-mode)

;; Buffcycle - simple Buffer cycling for Emacs between file buffers

(load-file "~/.emacs.d/buffcycle.el")
(require 'buffcycle)

;; Development tool which may help to bump versions

(add-to-list 'load-path (oo-elisp-path "emacs-bump-version/"))
(require 'bump-version)

(global-set-key (kbd "C-c C-b p") 'bump-version-patch)
(global-set-key (kbd "C-c C-b i") 'bump-version-minor)
(global-set-key (kbd "C-c C-b m") 'bump-version-major)

;; Cedet

(semantic-mode 1)

(add-to-list 'load-path (oo-elisp-path "cedet/contrib"))

(when (not (osx))
  (require 'eassist))

(eval-after-load "eassist"
  '(global-set-key [f3] 'psw-switch-function))

;; Color Identifiers Mode

(add-hook 'emacs-lisp-mode-hook 'color-identifiers-mode)

(setq global-color-identifiers-mode t)

;; ???

(add-hook 'comint-output-filter-functions
          'comint-watch-for-password-prompt)

;; cu - function which allows to quickly cd to the home directory of the given user

(defun system-users ()
  (split-string
   (shell-command-to-string "grep -o '^[^:]*' /etc/passwd | tr '\n' ' '") " "))

(defun cu (user)
  "cd to the USER's home directory."
  (interactive
   (list
    (completing-read "User: " (system-users))))
  (setq default-directory
        (replace-regexp-in-string "\n" "" (shell-command-to-string
                                           (format "grep %s /etc/passwd | cut -f 6 -d :" user))))
  (call-interactively 'ido-find-file))

;; cursor-chg - makes cursor much more interactive. Love this mode very much!

(require 'cursor-chg)  ; Load this library
(change-cursor-mode 1) ; On for overwrite/read-only/input mode
(toggle-cursor-type-when-idle 1) ; On when idle

(setq curchg-default-cursor-color "light blue")
(setq-default x-stretch-cursor t)

;; dictem - Emacs interface to the dictem

(when (not (osx))
  (add-to-list 'load-path (expand-file-name "~/.emacs.d/dictem-1.0.4"))
  (require 'dictem)

  (setq dictem-server "localhost")
  (dictem-initialize)
  (define-key mode-specific-map [?s] 'dictem-run-search)
  (global-set-key "\C-cs" 'dictem-run-search)
  (global-set-key "\C-cm" 'dictem-run-match)

  (define-key dictem-mode-map [tab] 'dictem-next-link)
  (define-key dictem-mode-map [(backtab)] 'dictem-previous-link))

;; For creating hyperlinks on database names and found matches.
;; Click on them with `mouse-2'
(add-hook 'dictem-postprocess-match-hook
          'dictem-postprocess-match)

;; For highlighting the separator between the definitions found.
;; This also creates hyperlink on database names.
(add-hook 'dictem-postprocess-definition-hook
          'dictem-postprocess-definition-separator)

;; For creating hyperlinks in dictem buffer that contains definitions.
(add-hook 'dictem-postprocess-definition-hook
          'dictem-postprocess-definition-hyperlinks)

;; For creating hyperlinks in dictem buffer that contains information
;; about a database.
(add-hook 'dictem-postprocess-show-info-hook
          'dictem-postprocess-definition-hyperlinks)

;; Dired and Dired+ configuration

(setq dired-listing-switches "-alGh")

(defun demi/dired-load-hook ()
  (interactive)
  (load "dired-x"))

(add-hook 'dired-load-hook 'demi/dired-load-hook)

(require 'dired+)

;; dired-details configuration

;; (add-to-list 'load-path "~/.emacs.d/el-get/dired-details/")

(require 'dired-details)
(dired-details-install)
(setq dired-details-hidden-string "* ")

;; discover

(require 'discover)
(global-discover-mode 1)

;; edebug configuration

;; Did you know edebug has a trace function? I didn't. Thanks, agumonkey!
(setq edebug-trace t)

;; While edebugging, use T to view a trace buffer
;; (*edebug-trace*). Emacs will quickly execute the rest of your code,
;; printing out the arguments and return values for each expression it
;; evaluates.  Eldoc provides minibuffer hints when working with
;; Emacs Lisp.

;; Some key bindings for the text editing

(global-set-key (kbd "H-k") 'kill-line)
(global-set-key (kbd "H-s") 'save-buffer)
(when (osx)
  (global-set-key (kbd "<f13>") 'save-buffer))
(global-set-key (kbd "<XF86Tools>") 'save-buffer)

(defun demi/end-of-line-return ()
  (interactive)
  (move-end-of-line 1)
  (newline-and-indent))

(defun demi/end-of-line-insert ()
  (interactive)
  (end-of-sexp)
  (newline-and-indent)
  (yank))

(global-set-key (kbd "S-<return>") 'demi/end-of-line-return)
(define-key global-map (kbd "RET") 'newline-and-indent)

;; eshell configuration

(setq eshell-cmpl-cycle-completions nil
      eshell-save-history-on-exit t
      eshell-cmpl-dir-ignore "\\`\\(\\.\\.?\\|CVS\\|\\.svn\\|\\.git\\)/\\'")

(setenv "PATH"
        (concat
         "/usr/local/bin:/usr/local/sbin:"
         (getenv "PATH")))

(when (osx)
  (setenv "PYTHONPATH" "/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/site-packages/:"))

(setenv "PAGER" "cat")

(defalias 'e 'find-file)
(defalias 'emacs 'find-file)

(defalias 'ee 'find-file-other-window)

(defun eshell/gst (&rest args)
  (magit-status (pop args) nil))

(defun eshell/oo ()
  (cd "/str/development/projects/open-source/"))

(defun eshell/today ()
  (org-batch-agenda "a"))
  ;; (save-window-excursion (prog1 (org-batch-agenda "a") (message ""))))

(defun eshell/todo ()
  (save-window-excursion (prog1 (org-batch-agenda "t") (message ""))))

(defun gt (source-language target-language text)
  (let ((translated-text ""))
    (save-window-excursion
      (google-translate-translate source-language target-language text)
      (message "")
      (with-current-buffer "*Google Translate*"
        (buffer-substring-no-properties (point-min) (point-max))))))

(defun eshell/l (&rest args)
  (dired (pop args) nil))

(eval-after-load 'esh-opt
  '(progn
     (require 'em-cmpl)
     (require 'em-prompt)
     (require 'em-term)
     ;; TODO: for some reason requiring this here breaks it, but
     ;; requiring it after an eshell session is started works fine.
     ;; (require 'eshell-vc)
     (setenv "PAGER" "cat")
     ; (set-face-attribute 'eshell-prompt nil :foreground "turquoise1")
     (add-hook 'eshell-mode-hook ;; for some reason this needs to be a hook
               '(lambda () (define-key eshell-mode-map "\C-a" 'eshell-bol)))
     (add-hook 'eshell-mode-hook
               '(lambda nil
                  (add-to-list 'eshell-visual-commands "ssh")
                  (add-to-list 'eshell-visual-commands "tail")))
     (add-to-list 'eshell-visual-commands "ssh")
     (add-to-list 'eshell-visual-commands "tail")
     (add-to-list 'eshell-command-completions-alist
                  '("gunzip" "gz\\'"))
     (add-to-list 'eshell-command-completions-alist
                  '("tar" "\\(\\.tar|\\.tgz\\|\\.tar\\.gz\\)\\'"))
     ;; (add-to-list 'eshell-output-filter-functions 'eshell-handle-ansi-color)
))

(defmacro with-face (str &rest properties)
  `(propertize ,str 'face (list ,@properties)))

(defun shk-eshell-prompt ()
  (let ((header-bg "#fff")
        (face 'bongo-unfilled-seek-bar))
    (concat
     ;; (with-face (concat (eshell/pwd) " ") face)
     ;; (with-face (format-time-string "(%Y-%m-%d %H:%M) " (current-time)) face)
     ;; (with-face
     ;;  (or (ignore-errors (format "(%s)" (vc-responsible-backend default-directory))) ""))
     ;; (with-face "\n" face)
     (with-face user-login-name 'clojure-test-failure-face)
     "@"
     (with-face "localhost" 'clojure-test-success-face)
     (if (= (user-uid) 0)
         (with-face " #" :foreground "red")
       " $")
     " ")))

(setq eshell-prompt-function 'shk-eshell-prompt)
(setq eshell-highlight-prompt nil)

;; expand-region configuration

(require 'expand-region)
(global-set-key (kbd "H-r") 'er/expand-region)
(global-set-key (kbd "<XF86Launch8>") 'er/expand-region)

;; yas configuration

(yas-global-mode)

(defun gnt/yas-minor-mode-hook ()
  "Personal customizations."
  (define-key yas-minor-mode-map (kbd "<tab>") 'yas-expand)
  (define-key yas-minor-mode-map (kbd "TAB") 'yas-expand)
  ;; (define-key yas-minor-mode-map (kbd "H-[") 'yas-expand)
  )

(add-hook 'yas-minor-mode-hook 'gnt/yas-minor-mode-hook)

;; whitespace configuration

(require 'whitespace)
(setq whitespace-style '(trailing lines tab-mark))
(setq whitespace-line-column 80)
(global-whitespace-mode 1)

;; (gcr/diminish 'global-whitespace-mode)
;; (gcr/diminish 'whitespace-mode)

;; ido configuration

(ido-mode 1)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(setq ido-enable-prefix nil)

(setq ido-decorations                                                      ; Make ido-mode display vertically
      (quote
       ("\n-> "           ; Opening bracket around prospect list
        ""                ; Closing bracket around prospect list
        "\n   "           ; separator between prospects
        "\n   ..."        ; appears at end of truncated list of prospects
        "["               ; opening bracket around common match string
        "]"               ; closing bracket around common match string
        " [No match]"     ; displayed when there is no match
        " [Matched]"      ; displayed if there is a single match
        " [Not readable]" ; current diretory is not readable
        " [Too big]"      ; directory too big
        " [Confirm]")))   ; confirm creation of new file or buffer

(add-hook 'ido-setup-hook                                                  ; Navigate ido-mode vertically
          (lambda ()
            (define-key ido-completion-map [down] 'ido-next-match)
            (define-key ido-completion-map [up] 'ido-prev-match)
            (define-key ido-completion-map (kbd "C-n") 'ido-next-match)
            (define-key ido-completion-map (kbd "C-p") 'ido-prev-match)
            (define-key ido-completion-map (kbd "H-h") 'ido-next-match)
            (define-key ido-completion-map (kbd "H-t") 'ido-prev-match)))

;; iedit configuration

(require 'iedit)

(defun iedit-dwim (arg)
  "Starts iedit but uses \\[narrow-to-defun] to limit its scope."
  (interactive "P")
  (if arg
      (iedit-mode)
    (save-excursion
      (save-restriction
        (widen)
        ;; this function determines the scope of `iedit-start'.
        (if iedit-mode
            (iedit-done)
          ;; `current-word' can of course be replaced by other
          ;; functions.
          (narrow-to-defun)
          (iedit-start (current-word) (point-min) (point-max)))))))

;; Pretify look and feel of scratch buffer on start up

(defvar initial-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c c") 'lisp-interaction-mode)
    (define-key map (kbd "C-c C-c") 'lisp-interaction-mode)
    map)
  "Keymap for `initial-mode'.")

(define-derived-mode initial-mode nil "Initial"
  "Major mode for start up buffer.
\\{initial-mode-map}"
  (setq-local text-mode-variant t)
  (setq-local indent-line-function 'indent-relative))

(setq initial-major-mode 'initial-mode
      initial-scratch-message "
;; ╔═╗┌┬┐┌─┐┌─┐┌─┐  ┬┌─┐  ┌─┐┬ ┬┌─┐┌─┐┌─┐┌┬┐┌─┐┬
;; ║╣ │││├─┤│  └─┐  │└─┐  ├─┤│││├┤ └─┐│ ││││├┤ │
;; ╚═╝┴ ┴┴ ┴└─┘└─┘  ┴└─┘  ┴ ┴└┴┘└─┘└─┘└─┘┴ ┴└─┘o
;;
;;                   __         _,******
;;               ,-----,        _  _,**
;;               | Mu! |          _   ____,****
;;               ;-----;        _
;;                    \\   ^__^
;;                     \\  (^^)\\_______
;;                       ^-(..)\\       )\\/\\/^_^
;;                             ||----w |
;;              __.-''*-,.,____||_____||___,_.-
;;                   ''     ''

")

;; jumpc configuration

(require 'jumpc)
(jumpc)
(jumpc-bind-vim-key)

;; js configuration

(setq js-indent-level 4)

;; config look and feel of fringes

(require 'git-gutter)
(global-git-gutter-mode +1)

(setq-default left-fringe-width 20)

(add-hook 'python-mode-hook 'git-gutter-mode)
(add-hook 'lisp-mode-hook 'git-gutter-mode)

(require 'fringe-helper)

(when (not (osx))
  (require 'git-gutter-fringe)
  (global-git-gutter-mode +1)
  (setq-default indicate-buffer-boundaries 'left)
  (setq-default indicate-empty-lines +1))

;; google-translate

(add-to-list 'load-path (oo-elisp-path "google-translate/"))
(require 'google-translate)
(require 'google-translate-smooth-ui)

(global-set-key (kbd "\C-c g t") 'google-translate-smooth-translate)

(setq google-translate-show-phonetic t)
(setq google-translate-input-method-auto-toggling t)
(setq google-translate-preferable-input-methods-alist '((nil . ("en"))
                   (ukrainian-programmer-dvorak . ("ru" "uk"))))

(setq google-translate-translation-directions-alist
      '(("en" . "ru")
        ("ru" . "en")
        ("en" . "uk")
        ("uk" . "en")
        ("uk" . "ru")
        ("ru" . "uk")))

(setq google-translate-pop-up-buffer-set-focus t)
(setq google-translate-inline-editing t)

;; google-this mode

(require 'google-this)
(google-this-mode 1)

;; deft mode
;; (require 'deft)
;; (setq deft-extension "org")
;; (setq deft-directory "~/git/org")
;; (setq deft-text-mode 'org-mode)
;; (setq deft-use-filename-as-title t)

;; configure gpg-agent

;; prompt for the password in the Emacs minibuffer (instead of using a
;; graphical password prompt for gpg)
(setenv "GPG_AGENT_INFO" nil)

;; guide-key-mode

(require 'guide-key)
(setq guide-key/guide-key-sequence '("C-x r" "C-x 4"))
(guide-key-mode 1)  ; Enable guide-key-mode

(defun demi/guide-key-org-mode-hook ()
  (guide-key/add-local-guide-key-sequence "C-c")
  (guide-key/add-local-guide-key-sequence "C-c C-x")
  (guide-key/add-local-highlight-command-regexp "org-"))

(add-hook 'org-mode-hook 'demi/guide-key-org-mode-hook)

;; erc configuration

(setq erc-hide-list '("JOIN" "QUIT"))

(defun bitlbee ()
  "Connect to IM networks using bitlbee."
  (interactive)
  (erc :server "localhost" :port 6667 :nick "demi"))

(defmacro asf-erc-bouncer-connect (command server port nick ssl pass)
  "Create interactive command `command', for connecting to an IRC server. The
   command uses interactive mode if passed an argument."
  (fset command
        `(lambda (arg)
           (interactive "p")
           (if (not (= 1 arg))
               (call-interactively 'erc)
             (let ((erc-connect-function ',(if ssl
                                               'erc-open-ssl-stream
                                             'open-network-stream)))
               (erc :server ,server :port ,port :nick ,nick :password ,pass))))))

(asf-erc-bouncer-connect erc-freenode "irc.freenode.net" 6667 "andrik" nil nil)
(asf-erc-bouncer-connect erc-twice "rc.twice-irc.de" 6667 "andrik" nil nil)

;; fires up a new frame and opens your servers in there. You will need
;; to modify it to suit your needs.
(defun my-irc ()
  "Start to waste time on IRC with ERC."
  (interactive)
  (call-interactively 'erc-freenode)
  (sit-for 1)
  (call-interactively 'erc-open))


(setq erc-autojoin-channels-alist
      '(("freenode.net" "#emacs" "#org-mode"
         "#hacklabto" "##linux" "#wiki"
         "#nethack" "#gnustep" "#gentoo" "django-cms")
        ("oftc.net" "#bitlbee")
        ("rc.twice-irc.de" "#i3")))

(setq erc-keywords '("demi" "demi:"
                     "fsbot:"
                     "howdoi" "Google Translate"
                     "google-translate"))
(erc-match-mode)
(erc-track-mode t)

(add-hook 'erc-mode-hook
          '(lambda ()
             (flyspell-mode)
             (pcomplete-erc-setup)
             (erc-completion-mode 1)))

(erc-fill-mode t)
(setq erc-fill-column 70)
(erc-ring-mode t)
(erc-netsplit-mode t)
(erc-timestamp-mode t)
(setq erc-timestamp-format "[%R-%m/%d]")
(erc-button-mode nil)

;; scrolling behavior

(setq redisplay-dont-pause t
      scroll-margin 1
      scroll-step 1
      scroll-conservatively 10000
      scroll-preserve-screen-position 1)

(setq mouse-wheel-follow-mouse 't)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))

;; logging:
(setq erc-log-insert-log-on-open t)
(setq erc-log-channels t)
(setq erc-log-channels-directory "~/.irclogs/")
(setq erc-save-buffer-on-part t)
(setq erc-hide-timestamps nil)

(setq erc-max-buffer-size 20000)
(defvar erc-insert-post-hook)
(add-hook 'erc-insert-post-hook 'erc-truncate-buffer)
(setq erc-truncate-buffer-on-save t)

;; Clears out annoying erc-track-mode stuff for when we don't care.
;; Useful for when ChanServ restarts :P
(defun reset-erc-track-mode ()
  (interactive)
  (setq erc-modified-channels-alist nil)
  (erc-modified-channels-update))

(add-hook 'erc-after-connect
          '(lambda (SERVER NICK)
             (erc-message (format "PRIVMSG" "NickServ identify %s"
                                  demi/short-password))))

(defun browse-previous-link ()
  (interactive)
  (org-previous-link)
  (find-file-at-point))

(define-key erc-mode-map (kbd "H-p") 'browse-previous-link)

;; emacs-lisp-mode

(setq lispy-no-space t)

(defun demi/lisp-mode-hook ()
  (interactive)
  (abbrev-mode)
  (speed-of-thought-mode)
  ;; (global-set-key (kbd "C-k") 'dtc-detach-ck-cursor)
  ;; (global-set-key (kbd "M-d") 'dtc-detach-metad-cursor)
  ;; (define-key paredit-mode-map (kbd "C-k") 'dtc-detach-ck-cursor)
  ;; (define-key paredit-mode-map (kbd "M-d") 'dtc-detach-metad-cursor)
  )

(add-hook 'lisp-mode-hook 'demi/lisp-mode-hook)
(add-hook 'emacs-lisp-mode-hook 'demi/lisp-mode-hook)

;; ezbl configuration

;; (add-to-list 'load-path (oo-elisp-path "ezbl/"))
;; (require 'ezbl)

;; fancy narrow
;; (require 'fancy-narrow)

;; fci

(setq fci-rule-width 12)

(defun fci-mode-with-rule-column (rule-column)
  (setq fci-rule-column rule-column)
  (fci-mode))

(defun fci-mode-72 ()
  (interactive)
  (fci-mode-with-rule-column 72))

(defun fci-mode-80 ()
  (interactive)
  (fci-mode-with-rule-column 80))

(defun fci-mode-100 ()
  (interactive)
  (fci-mode-with-rule-column 100))

(defun fci-mode-120 ()
  (interactive)
  (fci-mode-with-rule-column 120))

;; feature-mode

(add-to-list 'load-path (oo-elisp-path "cucumber.el/"))

(require 'feature-mode)
(add-to-list 'auto-mode-alist '("\.feature$" . feature-mode))

;; fill-column

(defun set-fill-column-num (num)
  (set-fill-column num))

(defun set-fill-column-100 ()
  (interactive)
  (set-fill-column-num 100))

;; flycheck

(require 'flycheck)

(add-hook 'after-init-hook #'global-flycheck-mode)
(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))

;; flyspell configuration

(defun flyspell-mode-enable-hook ()
  (interactive)
  (flyspell-mode))

(dolist (hook '(text-mode-hook org-mode-hook magit-log-edit-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))

(when (not (osx))
  (dolist (hook '(change-log-mode-hook log-edit-mode-hook org-agenda-mode-hook))
    (add-hook hook (lambda () (flyspell-mode -1))))

  ;; Add spell-checking in comments for all programming language modes
  (if (fboundp 'prog-mode)
      (add-hook 'prog-mode-hook 'flyspell-prog-mode)
    (dolist (hook '(lisp-mode-hook
                    emacs-lisp-mode-hook
                    scheme-mode-hook
                    clojure-mode-hook
                    ruby-mode-hook
                    yaml-mode
                    python-mode-hook
                    shell-mode-hook
                    php-mode-hook
                    css-mode-hook
                    haskell-mode-hook
                    caml-mode-hook
                    nxml-mode-hook
                    crontab-mode-hook
                    perl-mode-hook
                    tcl-mode-hook
                    javascript-mode-hook))
      (add-hook hook 'flyspell-prog-mode)))

  (eval-after-load 'flyspell
    '(add-to-list 'flyspell-prog-text-faces 'nxml-text-face)))


;; flymake configuration

(setq flymake-gui-warnings-enabled nil)

(setq flymake-start-syntax-check-on-find-file nil)

;;;; Source: https://gist.github.com/gregnewman/209934
;;;; Syntax Check using flymake and PyFlakes EMACS 23.x GUI
;;;; Emacs 23.x on Mac OS X has problems respecting system
;;;; paths so we have to add it manually with setq

;; (setq pyflakes "/usr/local/bin/pyflakes")

;; (when (load "flymake" t)
;;   (defun flymake-pyflakes-init ()
;;     (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                        'flymake-create-temp-inplace))
;;            (local-file (file-relative-name
;;                         temp-file
;;                         (file-name-directory buffer-file-name))))
;;       (list pyflakes (list local-file))))
;;   (add-to-list 'flymake-allowed-file-name-masks
;;                '("\\.py\\'" flymake-pyflakes-init)))
;; (add-hook 'find-file-hook 'flymake-find-file-hook)

(defun set-exec-path-from-shell-PATH ()
  "Set up Emacs' `exec-path' and PATH environment variable to match that used by the user's shell.

This is particularly useful under Mac OSX, where GUI apps are not started from a shell."
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string "[ \t\n]*$" "" (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(set-exec-path-from-shell-PATH)


;;;; Syntax Check using flymake and PyFlakes NON-EMACS 23.x

;; (when (load "flymake" t)
;;   (defun flymake-pyflakes-init ()
;;     (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                        'flymake-create-temp-inplace))
;;            (local-file (file-relative-name
;;                         temp-file
;;                         (file-name-directory buffer-file-name))))
;;       (list "pyflakes" (list local-file))))
;;   (add-to-list 'flymake-allowed-file-name-masks
;;                '("\\.py\\'" flymake-pyflakes-init)))

;; (add-hook 'find-file-hook 'flymake-find-file-hook)

;; (dolist (hook '(change-log-mode-hook log-edit-mode-hook org-agenda-mode-hook))
;;   (add-hook hook (lambda () (flyspell-mode -1))))

;; Add spell-checking in comments for all programming language modes
;; (if (fboundp 'prog-mode)
;;     (add-hook 'prog-mode-hook 'flyspell-prog-mode)
;;   (dolist (hook '(lisp-mode-hook
;;                   emacs-lisp-mode-hook
;;                   scheme-mode-hook
;;                   clojure-mode-hook
;;                   ruby-mode-hook
;;                   yaml-mode
;;                   python-mode-hook
;;                   shell-mode-hook
;;                   php-mode-hook
;;                   css-mode-hook
;;                   haskell-mode-hook
;;                   caml-mode-hook
;;                   nxml-mode-hook
;;                   crontab-mode-hook
;;                   perl-mode-hook
;;                   tcl-mode-hook
;;                   javascript-mode-hook))
;;     (add-hook hook 'flyspell-prog-mode)))

(eval-after-load 'flyspell
  '(add-to-list 'flyspell-prog-text-faces 'nxml-text-face))

;;; Web development configuration (identation)
;;; Source: http://blog.binchen.org/posts/easy-indentation-setup-in-emacs-for-web-development.html

(defun my-setup-indent (n)
  ;; web development
  (setq coffee-tab-width n) ; coffeescript
  (setq javascript-indent-level n) ; javascript-mode
  (setq js-indent-level n) ; js-mode
  (setq js2-basic-offset n) ; js2-mode
  (setq web-mode-markup-indent-offset n) ; web-mode, html tag in html file
  (setq web-mode-css-indent-offset n) ; web-mode, css in html file
  (setq web-mode-code-indent-offset n) ; web-mode, js code in html file
  (setq css-indent-offset n) ; css-mode
  )

(defun my-office-code-style ()
  (interactive)
  (message "Office code style!")
  (setq indent-tabs-mode nil)
  (my-setup-indent 4) ; indent 4 spaces width
  )

(defun my-personal-code-style ()
  (interactive)
  (message "My personal code style!")
  (setq indent-tabs-mode nil) ; use space instead of tab
  (my-setup-indent 2) ; indent 2 spaces width
  )

(my-office-code-style)

;; i3

;; (require 'i3)
;; (require 'i3-integration)

;; helm configuration

(require 'helm-config)

;;; Google Suggestions
;;
;;
;; Internal
(defvar helm-ggs-max-length-real-flag 0)
(defvar helm-ggs-max-length-num-flag 0)

(defun helm-google-suggest-fetch (input)
  "Fetch suggestions for INPUT from XML buffer.
Return an alist with elements like (data . number_results)."
  (setq helm-ggs-max-length-real-flag 0
        helm-ggs-max-length-num-flag 0)
  (let ((request (concat helm-google-suggest-url
                         (url-hexify-string input)))
        (fetch #'(lambda ()
                   (cl-loop
                    with result-alist = (xml-get-children
                                         (car (xml-parse-region
                                               (point-min) (point-max)))
                                         'CompleteSuggestion)
                    for i in result-alist
                    for data = (cdr (cl-caadr (assoc 'suggestion i)))
                    for nqueries = (cdr (cl-caadr (assoc 'num_queries i)))
                    for lqueries = (length (helm-ggs-set-number-result
                                            nqueries))
                    for ldata = (length data)
                    do
                    (progn
                      (when (> ldata helm-ggs-max-length-real-flag)
                        (setq helm-ggs-max-length-real-flag ldata))
                      (when (> lqueries helm-ggs-max-length-num-flag)
                        (setq helm-ggs-max-length-num-flag lqueries)))
                    collect (cons data nqueries) into cont
                    finally return cont))))
    (if helm-google-suggest-use-curl-p
        (with-temp-buffer
          (call-process "curl" nil t nil request)
          (funcall fetch))
      (with-current-buffer
          (url-retrieve-synchronously request)
        (funcall fetch)))))

(defun helm-google-suggest-set-candidates (&optional request-prefix)
  "Set candidates with result and number of google results found."
  (let ((suggestions
         (cl-loop with suggested-results = (helm-google-suggest-fetch
                                            (or (and request-prefix
                                                     (concat request-prefix
                                                             " " helm-pattern))
                                                helm-pattern))
                  for (real . numresult) in suggested-results
                  ;; Prepare number of results with ","
                  for fnumresult = (helm-ggs-set-number-result numresult)
                  ;; Calculate number of spaces to add before fnumresult
                  ;; if it is smaller than longest result
                  ;; `helm-ggs-max-length-num-flag'.
                  ;; e.g 1,234,567
                  ;;       345,678
                  ;; To be sure it is aligned properly.
                  for nspaces = (if (< (length fnumresult)
                                       helm-ggs-max-length-num-flag)
                                    (- helm-ggs-max-length-num-flag
                                       (length fnumresult))
                                  0)
                  ;; Add now the spaces before fnumresult.
                  for align-fnumresult = (concat (make-string nspaces ? )
                                                 fnumresult)
                  for interval = (- helm-ggs-max-length-real-flag
                                    (length real))
                  for spaces   = (make-string (+ 2 interval) ? )
                  for display = (format "%s%s(%s results)"
                                        real spaces align-fnumresult)
                  collect (cons display real))))
    (if (cl-loop for (_disp . dat) in suggestions
                 thereis (equal dat helm-pattern))
        suggestions
      ;; if there is no suggestion exactly matching the input then
      ;; prepend a Search on Google item to the list
      (append
       suggestions
       (list (cons (concat "Search for " "'" helm-input "'" " on Google")
                   helm-input))))))

(defun helm-ggs-set-number-result (num)
  (if num
      (progn
        (and (numberp num) (setq num (number-to-string num)))
        (cl-loop for i in (reverse (split-string num "" t))
                 for count from 1
                 append (list i) into C
                 when (= count 3)
                 append (list ",") into C
                 and do (setq count 0)
                 finally return
                 (replace-regexp-in-string
                  "^," "" (mapconcat 'identity (reverse C) ""))))
    "?"))

(defun helm-google-suggest-action (candidate)
  "Default action to jump to a google suggested candidate."
  (let ((arg (concat helm-google-suggest-search-url
                     (url-hexify-string candidate))))
    (helm-aif helm-google-suggest-default-browser-function
              (funcall it arg)
              (helm-browse-url arg))))

(defvar helm-google-suggest-default-function
  'helm-google-suggest-set-candidates
  "Default function to use in helm google suggest.")

(defvar helm-source-google-suggest
  '((name . "Google Suggest")
    (candidates . (lambda ()
                    (funcall helm-google-suggest-default-function)))
    (action . (("Google Search" . helm-google-suggest-action)))
    (volatile)
    (requires-pattern . 3)))

;; (defun helm-google-suggest-emacs-lisp ()
;;   "Try to emacs lisp complete with google suggestions."
;;   (helm-google-suggest-set-candidates "emacs lisp"))

;; (setq helm-howdoi
;;       '((name . "howdoi google")
;;         (candidates . (lambda ()
;;                         (funcall helm-google-suggest-default-function)))
;;         (action . (("howdoi" . howdoi-query)))
;;         (volatile)
;;         (requires-pattern . 3)
;;         (delayed)))

;; ;; and then you can call howdoi via helm like this:
;; ;; (helm :sources 'helm-howdoi)

;; (defun helm-howdoi-with-google-suggest ()
;;   (interactive)
;;   (helm :sources 'helm-howdoi))

;; (global-set-key (kbd "C-c o g") 'helm-howdoi-with-google-suggest)

;; (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)
;; (define-key helm-map (kbd "C-M-i") 'helm-select-action)

(setq helm-quick-update t
      helm-idle-delay 0.01
      helm-input-idle-delay 0.01)

;; helm-dash

(require 'helm-dash)

;; helm-github-stars

(require 'helm-github-stars)
(setq helm-github-stars-username "atykhonov")

;; howdoi configuration

(load-file (oo-elisp-path "emacs-howdoi/howdoi.el"))

(global-set-key (kbd "C-c o q") 'howdoi-query)

(setq helm-howdoi
      '((name . "howdoi google")
        (candidates . (lambda ()
                        (funcall helm-google-suggest-default-function)))
        (action . (("howdoi" . howdoi-query)))
        (volatile)
        (requires-pattern . 3)
        (delayed)))

;; and then you can call howdoi via helm like this:
;; (helm :sources 'helm-howdoi)

(defun helm-howdoi-with-google-suggest ()
  (interactive)
  (helm :sources 'helm-howdoi))

(global-set-key (kbd "C-c o g") 'helm-howdoi-with-google-suggest)

;; ibuffer configuration

(setq ibuffer-show-empty-filter-groups nil)
(setq ibuffer-saved-filter-groups
      '(("default"
         ("version control" (or (mode . svn-status-mode)
                                (mode . svn-log-edit-mode)
                                (name . "^\\*svn-")
                                (name . "^\\*vc\\*$")
                                (name . "^\\*Annotate")
                                (name . "^\\*git-")
                                (name . "^\\*vc-")))
         ("emacs" (or (name . "^\\*scratch\\*$")
                      (name . "^\\*Messages\\*$")
                      (name . "^TAGS\\(<[0-9]+>\\)?$")
                      (name . "^\\*Help\\*$")
                      (name . "^\\*info\\*$")
                      (name . "^\\*Occur\\*$")
                      (name . "^\\*grep\\*$")
                      (name . "^\\*Compile-Log\\*$")
                      (name . "^\\*Backtrace\\*$")
                      (name . "^\\*Process List\\*$")
                      (name . "^\\*gud\\*$")
                      (name . "^\\*Man")
                      (name . "^\\*WoMan")
                      (name . "^\\*Kill Ring\\*$")
                      (name . "^\\*Completions\\*$")
                      (name . "^\\*tramp")
                      (name . "^\\*shell\\*$")
                      (name . "^\\*compilation\\*$")))
         ("emacs source" (or (mode . emacs-lisp-mode)
                             (filename . "/Applications/Emacs.app")
                             (filename . "/bin/emacs")))
         ("agenda" (or (name . "^\\*Calendar\\*$")
                       (name . "^diary$")
                       (name . "^\\*Agenda")
                       (name . "^\\*org-")
                       (name . "^\\*Org")
                       (mode . org-mode)
                       (mode . muse-mode)))
         ("latex" (or (mode . latex-mode)
                      (mode . LaTeX-mode)
                      (mode . bibtex-mode)
                      (mode . reftex-mode)))
         ("dired" (or (mode . dired-mode))))))

(add-hook 'ibuffer-mode-hook
          (lambda ()
            (ibuffer-switch-to-saved-filter-groups "default")))

;; Order the groups so the order is : [Default], [agenda], [emacs]
(defadvice ibuffer-generate-filter-groups (after reverse-ibuffer-groups ()
                                                 activate)
  (setq ad-return-value (nreverse ad-return-value)))

;; iregister configuration

(add-to-list 'load-path (oo-elisp-path "iregister.el/"))
(require 'iregister)

(global-set-key (kbd "H-v") 'iregister-jump-to-next-marker)
(global-set-key (kbd "H-z") 'iregister-jump-to-previous-marker)

(global-set-key (kbd "M-l") 'iregister-latest-text)
(global-set-key (kbd "M-c") 'iregister-text)
(global-set-key (kbd "M-C") 'iregister-next-text)

(global-set-key (kbd "M-w") 'iregister-point-or-text-to-register-kill-ring-save)
(global-set-key (kbd "C-w") 'iregister-copy-to-register-kill)
(global-set-key (kbd "M-y") 'iregister-latest-text)

;; jabber configuration

(setq jabber-account-list '(
                            ("atykhonov@jabber.n-ix.com.ua"
                             (:network-server . "jabber.n-ix.com.ua")
                             (:port . 5222))))

(setq jabber-history-enabled t
      jabber-use-global-history nil
      jabber-backlog-number 40
      jabber-backlog-days 30
      jabber-roster-line-format " %c %-25n %u %-8s  %S")

;; kill-and-join-forward

(defun kill-and-join-forward (&optional arg)
  (interactive "P")
  (if (and (eolp) (not (bolp)))
      (progn (forward-char 1)
             (just-one-space 0)
             (backward-char 1)
             (kill-line arg))
    (kill-line arg)))

(global-set-key "\C-k" 'kill-and-join-forward)

;; kill-region

(defadvice kill-region (before slickcut activate compile)
  "When called interactively with no active region, kill the
current line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (line-beginning-position)
           (line-beginning-position 2)))))

;; kill ring save

;; Change cutting behavior:
;; "Many times you'll do a kill-line command with the only intention of
;; getting the contents of the line into the killring. Here's an idea stolen
;; from Slickedit, if you press copy or cut when no region is active, you'll
;; copy or cut the current line."
;; <http://www.zafar.se/bkz/Articles/EmacsTips>
(defadvice kill-ring-save (before slickcopy activate compile)
  "When called interactively with no active region, copy the
current line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (line-beginning-position)
           (line-beginning-position 2)))))

;; lunar-mode

(when (not (osx))
  (add-to-list 'load-path (oo-elisp-path "lunar-mode-line/"))
  (require 'lunar-mode-line)
  (display-lunar-phase-mode))

;; lorem-ipsum

(defun lorem-ipsum ()
  (interactive)
  (insert "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."))

;; magit

(add-to-list 'load-path (oo-elisp-path "git-modes/"))
(add-to-list 'load-path (oo-elisp-path "magit/"))
(eval-after-load 'info
  '(progn (info-initialize)
          (add-to-list 'Info-directory-list (oo-elisp-path "magit/"))))
(require 'magit)

(add-hook 'magit-log-edit-mode-hook 'flyspell-mode)

(global-set-key (kbd "H-i") 'magit-status)

(setenv "SSH_AUTH_SOCK" "")
(setenv "SSH_AGENT_PID" "")

(setq magit-auto-revert-mode nil)
(setq magit-last-seen-setup-instructions "1.4.0")

;; Source http://endlessparentheses.com/easily-create-github-prs-from-magit.html
(defun demi/visit-pull-request-url ()
  "Visit the current branch's PR on Github."
  (interactive)
  (browse-url
   (format "https://github.com/%s/compare/%s"
           (replace-regexp-in-string
            "\\`.+github\\.com:\\(.+\\)\\.git\\'" "\\1"
            (magit-get "remote"
                       (magit-get-current-remote)
                       "url"))
           (magit-get-current-branch))))

(eval-after-load 'magit
  '(define-key magit-mode-map "V"
     #'demi/visit-pull-request-url))

;; makefile-mode configuration

(defun makefile-indentation ()
  (interactive)
  (setq-default indent-tabs-mode nil)
  (setq-default tab-width 4)
  (setq indent-line-function 'insert-tab))

(add-hook 'makefile-mode-hook 'makefile-indentation)

;; markdown-mode configuration

(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))

;; miscellaneous

(global-set-key (kbd "H-/") 'smex)
(global-set-key (kbd "H-g") 'keyboard-quit)

(global-set-key (kbd "~") #'endless/~-or-emacs.d)

(defun endless/~-or-emacs.d ()
  (interactive)
  (if (window-minibuffer-p)
      (if (looking-back "~/")
          (insert ".emacs.d/")
        (insert "~/"))
    (insert "~")))

;; navi

(require 'navi-mode)

;; navigation within a buffer

(defvar demi-next-buffer "")

(defvar demi-prev-buffer "")

(defun demi/next-buffer ()
  (interactive)
  (setq demi-prev-buffer (buffer-name (current-buffer)))
  (next-buffer)
  (save-excursion
    (next-buffer)
    (setq demi-next-buffer (buffer-name (current-buffer)))))

(defun demi/prev-buffer ()
  (interactive)
  (setq demi-next-buffer (buffer-name (current-buffer)))
  (previous-buffer)
  (save-excursion
    (previous-buffer)
    (setq demi-prev-buffer (buffer-name (current-buffer)))))

(global-set-key (kbd "H-b") 'previous-buffer)
(global-set-key (kbd "H-l") 'next-buffer)
(global-set-key (kbd "H-l") 'next-buffer)

(global-set-key (kbd "H-O") 'switch-to-other-buffer)

(global-set-key (kbd "H--") 'newline)

(defun switch-to-other-buffer ()
  (interactive)
  (other-buffer 1))

(defun switch-to-previous-buffer ()
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

;; navigation within files

(recentf-mode 1) ; keep a list of recently opened files
(global-set-key (kbd "C-x C-r") 'recentf-open-files)

;; goto last change configuration

(global-set-key [(control ?.)] 'goto-last-change)
(global-set-key [(control ?,)] 'goto-last-change-reverse)

;; navigation within a mark

(defun buffer-order-next-mark (arg)
  (interactive "p")
  (when (mark)
    (let* ((p (point))
           (m (mark))
           (n p)
           (count (if (null arg) 1 arg))
           (abscount (abs count))
           (rel
            (funcall
             (if (< 0 count) 'identity 'reverse)
             (sort (cons (cons 0 p)
                         (cons (cons (- m p) m)
                               (if mark-ring
                                   (mapcar (lambda (mrm)
                                             (cons (- mrm p) mrm))
                                           mark-ring)
                                 nil)))
                   (lambda (c d) (< (car c) (car d))))))
           (cur rel))
      (while (and (numberp (caar cur)) (/= (caar cur) 0))
        (setq cur (cdr cur)))
      (while (and (numberp (caadr cur)) (= (caadr cur) 0))
        (setq cur (cdr cur)))
      (while (< 0 abscount)
        (setq cur (cdr cur))
        (when (null cur) (setq cur rel))
        (setq abscount (- abscount 1)))
      (when (number-or-marker-p (cdar cur))
        (goto-char (cdar cur))))))

(defun buffer-order-prev-mark (arg)
  (interactive "p")
  (buffer-order-next-mark
   (if (null arg) -1 (- arg))))

(global-set-key [C-s-right] 'buffer-order-next-mark)
(global-set-key [C-s-left] 'buffer-order-prev-mark)

;; point navigation

;; (setq scroll-preserve-screen-position t)

;; (defun buffer-order-next-mark (arg)
;;   (interactive "p")
;;   (when (mark)
;;     (let* ((p (point))
;;            (m (mark))
;;            (n p)
;;            (count (if (null arg) 1 arg))
;;            (abscount (abs count))
;;            (rel
;;             (funcall
;;              (if (< 0 count) 'identity 'reverse)
;;              (sort (cons (cons 0 p)
;;                          (cons (cons (- m p) m)
;;                                (if mark-ring
;;                                    (mapcar (lambda (mrm)
;;                                              (cons (- mrm p) mrm))
;;                                            mark-ring)
;;                                  nil)))
;;                    (lambda (c d) (< (car c) (car d))))))
;;            (cur rel))
;;       (while (and (numberp (caar cur)) (/= (caar cur) 0))
;;         (setq cur (cdr cur)))
;;       (while (and (numberp (caadr cur)) (= (caadr cur) 0))
;;         (setq cur (cdr cur)))
;;       (while (< 0 abscount)
;;         (setq cur (cdr cur))
;;         (when (null cur) (setq cur rel))
;;         (setq abscount (- abscount 1)))
;;       (when (number-or-marker-p (cdar cur))
;;         (goto-char (cdar cur))))))

;; (defun buffer-order-prev-mark (arg)
;;   (interactive "p")
;;   (buffer-order-next-mark
;;    (if (null arg) -1 (- arg))))

;; (defun demi/end-of-line-return ()
;;   (interactive)
;;   (move-end-of-line 1)
;;   (newline))

;; (defun demi/end-of-previous-line-return ()
;;   (interactive)
;;   (move-end-of-line 0)
;;   (newline))

;; (defun ctrl-e-in-vi (n)
;;   (interactive "p")
;;   (scroll-up n))

;; (defun ctrl-y-in-vi (n)
;;   (interactive "p")
;;   (scroll-down n))

;; (global-set-key (kbd "C-<return>") 'demi/end-of-line-return)
;; (global-set-key (kbd "S-C-<return>") 'demi/end-of-previous-line-return)

;; (global-set-key [C-s-right] 'buffer-order-next-mark)
;; (global-set-key [C-s-left] 'buffer-order-prev-mark)

;; seems is unneeded, will see
(defun at/end-of-buffer ()
  (interactive)
  (end-of-buffer)
  (forward-line -1))

(defun demi/set-mark-command ()
  (interactive)
  (set-mark-command 4))

(global-set-key (kbd "H-d") 'backward-char)
(global-set-key (kbd "H-h") 'next-line)
(global-set-key (kbd "H-t") 'previous-line)
(global-set-key (kbd "H-n") 'forward-char)

(global-set-key (kbd "H-$") 'demi/set-mark-command)

(global-set-key (kbd "C-H-S-t") 'beginning-of-buffer)
(global-set-key (kbd "C-H-S-h") 'end-of-buffer)

(global-set-key (kbd "H-,") 'beginning-of-buffer)
(global-set-key (kbd "H-.") 'end-of-buffer)

(global-set-key (kbd "<XF86Launch6>") 'beginning-of-buffer)
(global-set-key (kbd "<XF86Launch7>") 'end-of-buffer)

(when (osx)
  (global-set-key (kbd "<home>") 'move-beginning-of-line)
  (global-set-key (kbd "<end>") 'move-end-of-line)

  (global-set-key (kbd "<f2>") 'beginning-of-buffer)
  (global-set-key (kbd "<f16>") 'end-of-buffer)
  (global-set-key (kbd "<s-f15>") 'beginning-of-buffer)
  (global-set-key (kbd "<s-f16>") 'end-of-buffer)
  (global-set-key (kbd "<H-help>") 'clipboard-yank))

(global-set-key (kbd "C-H-t") 'backward-paragraph)
(global-set-key (kbd "C-H-h") 'forward-paragraph)

;; (global-set-key (kbd "H-T") 'ctrl-y-in-vi)
;; (global-set-key (kbd "H-H") 'ctrl-e-in-vi)

(global-set-key (kbd "H-M") 'backward-sexp)
(global-set-key (kbd "H-W") 'forward-sexp)

(global-set-key (kbd "H-m") 'backward-word)
(global-set-key (kbd "H-w") 'forward-word)

(global-set-key (kbd "C-H-d") 'move-beginning-of-line)
(global-set-key (kbd "C-H-n") 'move-end-of-line)

(global-set-key (kbd "H-a") 'move-beginning-of-line)
(global-set-key (kbd "H-e") 'move-end-of-line)

;; (global-set-key (kbd "H-/") 'switch-to-previous-buffer)
;; (global-set-key (kbd "H-b") 'previous-buffer)
;; (global-set-key (kbd "H-l") 'next-buffer)
;; (global-set-key (kbd "H-k") 'kill-line)
;; (global-set-key (kbd "H-s") 'save-buffer)

;; source: http://www.emacswiki.org/emacs/RecenterLikeVi
(defun line-to-top-of-window ()
  "Shift current line to the top of the window-  i.e. zt in Vim"
  (interactive)
  (set-window-start (selected-window) (point)))

(defun line-to-bottom-of-window ()
  "Shift current line to the botom of the window- i.e. zb in Vim"
  (interactive)
  (line-to-top-of-window)
  (scroll-down (- (window-height) 3)))

(defun search-sexp-at-point ()
  "Search the s-expression at the point."
  (interactive)
  (let ((string (buffer-substring-no-properties
                 (point)
                 (save-excursion (forward-sexp) (point)))))
    (forward-sexp)
    (search-forward string)))

;; navigation by means of scrolling

(setq scroll-preserve-screen-position t)

(defun ctrl-e-in-vi (n)
  (interactive "p")
  (scroll-up n))

(defun ctrl-y-in-vi (n)
  (interactive "p")
  (scroll-down n))

(global-set-key (kbd "H-T") 'ctrl-y-in-vi)
(global-set-key (kbd "H-H") 'ctrl-e-in-vi)

(global-set-key (kbd "<S-prior>") 'ctrl-y-in-vi)
(global-set-key (kbd "<S-next>") 'ctrl-e-in-vi)

;; navigation within the windows

(global-set-key (kbd "M-]") 'delete-other-windows) ; expand current pane
(global-set-key (kbd "M-+") 'split-window-horizontally) ; split pane top/bottom
(global-set-key (kbd "M-)") 'delete-window) ; close current pane
(global-set-key (kbd "M-*") 'other-window) ; cursor to other pane

(global-set-key (kbd "H-o") 'switch-to-other-window)
(global-set-key (kbd "<XF86Launch5>") 'switch-to-other-window)

(defun switch-to-other-window ()
  (interactive)
  (other-window 1))

;;; org-mode configuration

(when (not (osx))
  (load-file "~/.emacs.d/demi-org.el"))

(when (osx)
  (add-hook
   'org-clock-in-hook
   (lambda ()
     (call-process
      "/usr/bin/osascript"
      nil 0 nil "-e"
      (concat
       "tell application \"org-clock-statusbar\" to clock in \""
       org-clock-current-task "\""))))
  (add-hook
   'org-clock-out-hook
   (lambda ()
     (call-process
      "/usr/bin/osascript"
      nil 0 nil
      "-e" "tell application \"org-clock-statusbar\" to clock out"))))

;; pomodoro (found at https://github.com/grayhemp/emacs-configuration/blob/master/organizing.el)

;; Use org-clock
(require 'org-clock)

;; Turn org-clock sound on
(setq org-clock-sound t)

;; Set default countdown timer time to 25 min (Pomodoro)
(setq org-timer-default-timer 25)

;; The countdown timer is started automatically when a task is
;; clocking in, if it has not been started yet.
(setq org-timer-current-timer nil)
(setq pomodoro-is-active nil)
(add-hook 'org-clock-in-prepare-hook
	  '(lambda ()
	     (if (not pomodoro-is-active)
		 (let ((minutes (read-number "Start timer: " 25)))
		   (if org-timer-current-timer (org-timer-cancel-timer))
		   (org-timer-set-timer minutes)))
	     (setq pomodoro-is-active t)))
;(setq org-clock-in-prepare-hook nil)

;; The timer is finished automatically when a task is clocking
;; out. When finishing the timer it asks for a time interval of a
;; break, 5 minutes by default.
(add-hook 'org-clock-out-hook
	  '(lambda ()
	     (when (not org-clock-clocking-in)
               (progn
                 (org-timer-cancel-timer)
                 (setq pomodoro-is-active nil)))))
                                        ;(setq org-clock-out-hook nil)

(defun pomodoro-notification ()
  (interactive)
  (start-process-shell-command
   "mplayer" nil
   "mplayer /System/Library/Sounds/Glass.aiff")
  (sit-for 0.5))

;; Raise a notification after countdown done
(add-hook
 'org-timer-done-hook
 '(lambda ()
    (progn
      (when (osx)
        (start-process-shell-command
         "pomodoro-notification" nil
         "osascript -e 'tell app \"System Events\" to display alert \"Time is over!\" message \"Time is over.\"'"))
      (pomodoro-notification)
      (pomodoro-notification)
      (pomodoro-notification))))

(defun pomodoro-start ()
  (interactive)
  (org-clock-in))

(defvar pomodoro-count 0)

(defun pomodoro-day-new ()
  (interactive)
  (setq pomodoro-count 0)
  (org-insert-heading)
  (org-time-stamp nil)
  (org-do-promote)
  (org-insert-heading)
  (insert "P1")
  (org-do-demote)
  (org-clock-in))

(defun pomodoro-new ()
  (interactive)
  (setq pomodoro-count (+ pomodoro-count 1))
  (org-insert-heading nil)
  (insert "P" (int-to-string pomodoro-count) " ")
  (org-time-stamp t)
  (org-clock-in))

;; Emacs macro to add a pomodoro item
(fset 'pomodoro
      "[ ]")

;; Emacs macro to add a pomodoro table
;;
(fset 'pomodoro-table
      [?| ?  ?T ?a ?s ?k ?  ?| ?  ?\[ ?  ?\] ?  ?| tab])

;; osx-org-clock-menu-bar configuration

(when (osx)
  (load-file (oo-elisp-path "osx-org-clock-menubar/osx-org-clock-menubar.el"))
  (require 'osx-org-clock-menubar))

;; (require 'demi-org)

;; org-babel configuration

(setq org-src-fontify-natively t)

;; source: http://orgmode.org/manual/Languages.html#Languages
;; (org-babel-do-load-languages
;;  'org-babel-load-languages
;;  '((emacs-lisp . t)
;;    (python . t)
;;    (shell . t)
;;    (org . t)
;;    (ditaa . t)))

;; org-prettier-code-blocks

(defun prettier-org-code-blocks ()
  (interactive)
  (font-lock-add-keywords nil
                          '(("\\(\+begin_src\\)"
                             (0 (progn (compose-region (match-beginning 1) (match-end 1) ?¦)
                                       nil)))
                            ("\\(\+end_src\\)"
                             (0 (progn (compose-region (match-beginning 1) (match-end 1) ?¦)
                                       nil))))))

(add-hook 'org-mode-hook 'prettier-org-code-blocks)

;; paren-mode

(show-paren-mode t)
(setq show-paren-ring-bell-on-mismatch t)

;; popup-switcher

(require 'popup-switcher)

(global-set-key [f2] 'psw-switch-buffer)

;; popwin

(require 'popwin)

;; prodigy

(load-file "~/.emacs.d/demi-prodigy.el")

(require 'demi-prodigy)

;; python

(elpy-enable)
;; (elpy-use-ipython)

(eval-after-load "python"
  '(progn
     (define-key python-mode-map (kbd "C-h f") 'elpy-doc)
     (define-key python-mode-map (kbd "M-.") 'jedi:goto-definition)))

(require 'py-autopep8)
;; (add-hook 'before-save-hook 'py-autopep8-before-save)
(setq py-autopep8-options '("--max-line-length=100"))

;; (setq python-environment-directory "~/projects/ncc-web-jun")
(setq jedi:environment-root "~/projects/ncc-web-jun/.virtualenv/")

(setq jedi:server-args
      '("--virtual-env" "/Users/atykhonov/projects/ncc-web-jun/.virtualenv/"))

(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)
(setq jedi:environment-virtualenv "/Users/atykhonov/projects/ncc-web-jun/.virtualenv/")
;(setq python-environment-virtualenv
;      ("virtualenv" "--system-site-packages" "--quiet"))
;(setq python-environment-virtualenv
;      (append python-environment-virtualenv
;              '("--python" "/Users/atykhonov/projects/ncc-web-jun/.virtualenv/bin/python")))

;; javascript

(add-to-list 'auto-mode-alist '("\\.json$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

(add-hook 'js-mode-hook 'js2-minor-mode)
(add-hook 'js2-mode-hook 'ac-js2-mode)
(setq js2-highlight-level 3)

(add-hook 'js-mode-hook
          (lambda () (flycheck-mode t)))

(add-hook 'js2-mode-hook 'skewer-mode)
(add-hook 'css-mode-hook 'skewer-css-mode)
(add-hook 'html-mode-hook 'skewer-html-mode)

(autoload 'moz-minor-mode "moz"
  "Mozilla Minor and Inferior Mozilla Modes" t)

(add-hook 'js2-mode-hook 'javascript-custom-setup)
(defun javascript-custom-setup ()
  (moz-minor-mode 1))

(load-file "~/.emacs.d/init-js.el")
(require 'init-js)

;; rainbow-delimiters

(require 'rainbow-delimiters)
(add-hook 'python-mode-hook 'rainbow-delimiters-mode)
(add-hook 'python-mode-hook 'fci-mode-80)

;; readability

(when (not (osx))
  (load-file "~/.emacs.d/demi-readability.el")
  (require 'demi-readability))

;; rename-file-and-buffer

;; source: http://steve.yegge.googlepages.com/my-dot-emacs-file
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file name new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

;; saveplace - save cursor position in files when buffer changes

(require 'saveplace)
(setq-default save-place t)
(setq save-place-file "~/.emacs.d/saveplace")

;; shell-mode directory tracking in the modeline

(defun add-mode-line-dirtrack ()
  (add-to-list 'mode-line-buffer-identification
               '(:propertize (" " default-directory " ") face dired-directory)
               ))

(add-hook 'shell-mode-hook 'add-mode-line-dirtrack)

;; sauron

(when (not (osx))
  (load-file "~/.emacs.d/demi-sauron.el")
  (require 'demi-sauron))

;; smartparens

(smartparens-global-mode)

;; Source: https://github.com/Fuco1/smartparens/wiki/Example-configuration

;;;;;;;;;
;;; global
(require 'smartparens-config)
(smartparens-global-mode t)

;;; highlights matching pairs
(show-smartparens-global-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;
;;; keybinding management

(define-key sp-keymap (kbd "C-M-f") 'sp-forward-sexp)
(define-key sp-keymap (kbd "C-M-b") 'sp-backward-sexp)

(define-key sp-keymap (kbd "C-M-d") 'sp-down-sexp)
(define-key sp-keymap (kbd "C-M-a") 'sp-backward-down-sexp)
(define-key sp-keymap (kbd "C-S-a") 'sp-beginning-of-sexp)
(define-key sp-keymap (kbd "C-S-d") 'sp-end-of-sexp)

(define-key sp-keymap (kbd "C-M-e") 'sp-up-sexp)
(define-key emacs-lisp-mode-map (kbd ")") 'sp-up-sexp)
(define-key sp-keymap (kbd "C-M-u") 'sp-backward-up-sexp)
(define-key sp-keymap (kbd "C-M-t") 'sp-transpose-sexp)

(define-key sp-keymap (kbd "C-M-n") 'sp-next-sexp)
(define-key sp-keymap (kbd "C-M-p") 'sp-previous-sexp)

(define-key sp-keymap (kbd "C-M-k") 'sp-kill-sexp)
(define-key sp-keymap (kbd "C-M-w") 'sp-copy-sexp)

(define-key sp-keymap (kbd "M-<delete>") 'sp-unwrap-sexp)
(define-key sp-keymap (kbd "M-<backspace>") 'backward-kill-word)

(define-key sp-keymap (kbd "C-<right>") 'sp-forward-slurp-sexp)
(define-key sp-keymap (kbd "C-<left>") 'sp-forward-barf-sexp)
(define-key sp-keymap (kbd "C-M-<left>") 'sp-backward-slurp-sexp)
(define-key sp-keymap (kbd "C-M-<right>") 'sp-backward-barf-sexp)

(define-key sp-keymap (kbd "M-D") 'sp-splice-sexp)
(define-key sp-keymap (kbd "C-M-<delete>") 'sp-splice-sexp-killing-forward)
(define-key sp-keymap (kbd "C-M-<backspace>") 'sp-splice-sexp-killing-backward)
(define-key sp-keymap (kbd "C-S-<backspace>") 'sp-splice-sexp-killing-around)

(define-key sp-keymap (kbd "C-]") 'sp-select-next-thing-exchange)
(define-key sp-keymap (kbd "C-<left_bracket>") 'sp-select-previous-thing)
(define-key sp-keymap (kbd "C-M-]") 'sp-select-next-thing)

(define-key sp-keymap (kbd "M-F") 'sp-forward-symbol)
(define-key sp-keymap (kbd "M-B") 'sp-backward-symbol)

(define-key sp-keymap (kbd "C-M-r") 'sp-raise-sexp)

(define-key sp-keymap (kbd "H-t") 'sp-prefix-tag-object)
(define-key sp-keymap (kbd "H-p") 'sp-prefix-pair-object)
(define-key sp-keymap (kbd "H-s c") 'sp-convolute-sexp)
(define-key sp-keymap (kbd "H-s a") 'sp-absorb-sexp)
(define-key sp-keymap (kbd "H-s e") 'sp-emit-sexp)
(define-key sp-keymap (kbd "H-s p") 'sp-add-to-previous-sexp)
(define-key sp-keymap (kbd "H-s n") 'sp-add-to-next-sexp)
(define-key sp-keymap (kbd "H-s j") 'sp-join-sexp)
(define-key sp-keymap (kbd "H-s s") 'sp-split-sexp)

;;;;;;;;;;;;;;;;;;
;;; pair management

(sp-local-pair 'minibuffer-inactive-mode "'" nil :actions nil)

;;; markdown-mode
(sp-with-modes '(markdown-mode gfm-mode rst-mode)
  (sp-local-pair "*" "*" :bind "C-*")
  (sp-local-tag "2" "**" "**")
  (sp-local-tag "s" "```scheme" "```")
  (sp-local-tag "<"  "<_>" "</_>" :transform 'sp-match-sgml-tags))

;;; tex-mode latex-mode
(sp-with-modes '(tex-mode plain-tex-mode latex-mode)
  (sp-local-tag "i" "\"<" "\">"))

;;; html-mode
(sp-with-modes '(html-mode sgml-mode)
  (sp-local-pair "<" ">"))

;;; lisp modes
(sp-with-modes sp--lisp-modes
  (sp-local-pair "(" nil :bind "C-("))

;; sotlisp (Write lisp at the speed of thought)

(load-file "~/.emacs.d/sotlisp.el")
(require 'sotlisp)

;; smart-mode-line

(require 'smart-mode-line)

(setq sml/vc-mode-show-backend t)
(sml/setup)
(sml/apply-theme 'dark)

;; smart-forward

(require 'smart-forward)

;; smart-return

(when (not (osx))
  (add-to-list 'load-path (oo-elisp-path "emacs-smart-return/"))
  (require 'smart-return)
  (global-set-key (kbd "H-<return>") 'smart-return))

;; smex

(require 'smex)
(smex-initialize)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-x x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

;; Theme

(add-to-list 'custom-theme-load-path "~/emacs/packages/themes/tao-theme-emacs/")
;; (load-theme 'hc-zenburn t)
;; (load-theme 'base16-default-dark t)
;; (setq solarized-distinct-fringe-background +1)
;; (setq solarized-high-contrast-mode-line +1)
;; (setq solarized-use-less-bold +1)
;; (setq solarized-use-more-italic nil)
;; (setq solarized-emphasize-indicators nil)
;; (load-theme 'solarized-dark)
(load-theme 'tao-yin t)

;; Toggles between russian and ukrainian input methods

(defun toggle-alternative-input-method ()
  "Toggles between russian and ukrainian input methods"
  (interactive)
  (cond
   ((or (null current-input-method)
        (string= current-input-method "ukrainian-computer"))
    (activate-input-method 'russian-computer))
   ((string= current-input-method "russian-computer")
    (activate-input-method 'ukrainian-computer))))

(global-set-key "\C-x\\" 'toggle-alternative-input-method)
(global-set-key "\C-@" 'toggle-input-method)

;; Find file as root via the tramp

(load-file "~/.emacs.d/demi-tramp-find-file-root.el")
(require 'demi-tramp-find-file-root)

;; undo-tree

(require 'undo-tree)
(global-undo-tree-mode)
(defalias 'redo 'undo-tree-redo)

;; uniquify

(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; visible-mark

(require 'visible-mark)

;; w3m

(when (not (osx))
  (load-file "~/.emacs.d/demi-w3m.el")
  (require 'demi-w3m))

;; Swap two windows

;; swap 2 windows
(defun my-swap-windows ()
  "If you have 2 windows, it swaps them."
  (interactive)
  (cond ((not (= (count-windows) 2))
         (message "You need exactly 2 windows to do this."))
        (t
         (let* ((w1 (first (window-list)))
                (w2 (second (window-list)))
                (b1 (window-buffer w1))
                (b2 (window-buffer w2))
                (s1 (window-start w1))
                (s2 (window-start w2)))
           (set-window-buffer w1 b2)
           (set-window-buffer w2 b1)
           (set-window-start w1 s2)
           (set-window-start w2 s1)))))

(global-set-key (kbd "C-c ~") 'my-swap-windows)

;; Toggle window split

(defun my-toggle-window-split ()
  "Vertical split shows more of each line, horizontal split shows
more lines. This code toggles between them. It only works for
frames with exactly two windows."
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))

(global-set-key (kbd "C-c |") 'my-toggle-window-split)

;; workgroups configuration

(when (not (osx))
  (add-to-list 'load-path (oo-elisp-path "workgroups.el/"))
  (require 'workgroups)
  (setq wg-prefix-key (kbd "C-c z")))

;; ecco configuration

(add-to-list 'load-path (oo-ghq-path "github.com/capitaomorte/ecco/"))
(require 'ecco)

;; org-projectile

(when (not (osx))
  (add-to-list 'load-path (oo-ghq-path "github.com/IvanMalison/org-projectile"))
  (require 'org-projectile))

;; xml tools

(defun bf-pretty-print-xml-region (begin end)
  "Pretty format XML markup in region. You need to have nxml-mode
http://www.emacswiki.org/cgi-bin/wiki/NxmlMode installed to do
this.  The function inserts linebreaks to separate tags that have
nothing but whitespace between them.  It then indents the markup
by using nxml's indentation rules."
  (interactive "r")
  (save-excursion
      ;; (nxml-mode)
      (goto-char begin)
      (while (search-forward-regexp "\>[ \\t]*\<" nil t)
        (backward-char) (insert "\n"))
      (indent-region begin end))
    (message "Ah, much better!"))

(defun cheeso-pretty-print-xml-region (begin end)
  "Pretty format XML markup in region. You need to have nxml-mode
http://www.emacswiki.org/cgi-bin/wiki/NxmlMode installed to do
this.  The function inserts linebreaks to separate tags that have
nothing but whitespace between them.  It then indents the markup
by using nxml's indentation rules."
  (interactive "r")
  (save-excursion
    (nxml-mode)
    ;; split <foo><bar> or </foo><bar>, but not <foo></foo>
    (goto-char begin)
    (while (search-forward-regexp ">[ \t]*<[^/]" end t)
      (backward-char 2) (insert "\n") (incf end))
    ;; split <foo/></foo> and </foo></foo>
    (goto-char begin)
    (while (search-forward-regexp "<.*?/.*?>[ \t]*<" end t)
      (backward-char) (insert "\n") (incf end))
    ;; put xml namespace decls on newline
    (goto-char begin)
    (while (search-forward-regexp "\\(<\\([a-zA-Z][-:A-Za-z0-9]*\\)\\|['\"]\\) \\(xmlns[=:]\\)" end t)
      (goto-char (match-end 0))
      (backward-char 6) (insert "\n") (incf end))
    (indent-region begin end nil)
    (normal-mode))
  (message "All indented!"))

;; Utils configuration
;;
;; Source URL: https://github.com/grettke/home/blob/master/.emacs.el

(defun gnt/util-ielm ()
  "Personal buffer setup for ielm.
Creates enough space for one other permanent buffer beneath it."
  (interactive)
  (split-window-below -20)
  (ielm)
  (set-window-dedicated-p (selected-window) t))

(defun gnt/util-eshell ()
  "Personal buffer setup for eshell.
Depends upon `gcr/util-ielm' being run first."
  (interactive)
  (split-window-below -10)
  (other-window 1)
  (eshell)
  (set-window-dedicated-p (selected-window) t))

(defun gcr/util-eshell ()
  "Personal buffer setup for eshell.
Depends upon `gcr/util-ielm' being run first."
  (interactive)
  (split-window-below -10)
  (other-window 1)
  (eshell)
  (set-window-dedicated-p (selected-window) t))

(defvar gcr/util-state nil "Track whether the util buffers are displayed or not.")

(defun gcr/util-state-toggle ()
  "Toggle the util state."
  (interactive)
  (setq gcr/util-state (not gcr/util-state)))

(defun gcr/util-start ()
  "Perhaps utility buffers."
  (interactive)
  (gcr/util-ielm)
  (gcr/util-eshell)
  (gcr/util-state-toggle))

(defun gcr/util-stop ()
  "Remove personal utility buffers."
  (interactive)
  (if (get-buffer "*ielm*") (kill-buffer "*ielm*"))
  (if (get-buffer "*eshell*") (kill-buffer "*eshell*"))

  (gnt/util-state-toggle))

(defun gcr/util-cycle ()
  "Display or hide the utility buffers."
  (interactive)
  (if gcr/util-state
      (gcr/util-stop)
    (gcr/util-start)))

(defun gnt/ielm-auto-complete ()
  "Enables `auto-complete' support in \\[ielm].
Attribution: URL `http://www.masteringemacs.org/articles/2010/11/29/evaluating-elisp-emacs/'"
  (setq ac-sources '(ac-source-functions
                     ac-source-variables
                     ac-source-features
                     ac-source-symbols
                     ac-source-words-in-same-mode-buffers))
  (add-to-list 'ac-modes 'inferior-emacs-lisp-mode)
  (auto-complete-mode 1))

(defun gnt/chs ()
  "Insert opening \"cut here start\" snippet."
  (interactive)
  (insert "--8<---------------cut here---------------start------------->8---"))

(defun gnt/che ()
  "Insert closing \"cut here end\" snippet."
  (interactive)
  (insert "--8<---------------cut here---------------end--------------->8---"))

(defun gnt/insert-ellipsis ()
  "Insert an ellipsis into the current buffer."
  (interactive)
  (insert "…"))

(defun py/lines ()
  (interactive)
  (insert "print '\\n\\n\\n'"))

(defun py/break ()
  (interactive)
  (insert "print '#####################'"))

(defun py/print (text)
  (interactive "sText: ")
  (insert "print '\\n#####################'\n")
  (insert "print '##### " text "'\n")
  (insert "print '#####################\\n'\n")
  (save-excursion
    (search-backward "print " nil t 3)
    (indent-for-tab-command)
    (next-line)
    (indent-for-tab-command)
    (next-line)
    (indent-for-tab-command)))

(defun js/print (text)
  (interactive "sText: ")
  (insert (format "console.log('%s')" text))
  (save-excursion
    (search-backward "console.log(" nil t)
    (indent-for-tab-command)))

;; key-chord configuration

(key-chord-define-global "3." 'gnt/insert-ellipsis)
(key-chord-define-global "<<" (lambda () (interactive) (insert "«")))
(key-chord-define-global ">>" (lambda () (interactive) (insert "»")))
(key-chord-define-global "xx" 'smex)


(key-chord-mode 1)

;; dired configuration

(defun gnt/dired-copy-path ()
  "Push the path of the directory under the point to the kill ring.

Source URL: https://github.com/grettke/home/blob/master/.emacs.el"
  (interactive)
  (message "Added %s to kill ring" (kill-new default-directory)))

(defun gnt/dired-copy-filename ()
  "Push the path and filename of the file under the point to the kill ring.
Attribution: URL `https://lists.gnu.org/archive/html/help-gnu-emacs/2002-10/msg00556.html'
Source URL: https://github.com/grettke/home/blob/master/.emacs.el"
  (interactive)
  (message "Added %s to kill ring" (kill-new (dired-get-filename))))

(defun gcr/occur-mode-hook ()
  "Personal customizations."
  (interactive)
  (turn-on-stripe-buffer-mode)
  (stripe-listify-buffer))

(add-hook 'occur-mode-hook 'gcr/occur-mode-hook)

;; hippie expand

(global-set-key (kbd "M-/") 'hippie-expand)

(setq hippie-expand-try-functions-list
      '(try-complete-file-name-partially
        try-complete-file-name
        try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill))

;; django configuration

;; (autoload 'django-html-mode "django-html-mode")
(add-to-list 'auto-mode-alist '("\\.[sx]?html?\\'" . web-mode))

(defun django-insert-trans (from to &optional buffer)
  (interactive "*r")
  (save-excursion
    (save-restriction
      (narrow-to-region from to)
      (goto-char from)
      (iso-iso2sgml from to)
      (insert "{% trans \"")
      (goto-char (point-max))
      (insert "\" %}")
      (point-max))))

(defun django-insert-transpy (from to &optional buffer)
  (interactive "*r")
  (save-excursion
    (save-restriction
      (narrow-to-region from to)
      (goto-char from)
      (iso-iso2sgml from to)
      (insert "_(")
      (goto-char (point-max))
      (insert ")")
      (point-max))))

(add-hook 'sgml-mode-hook
          (lambda ()
            (local-set-key "\C-c\C-g" 'django-insert-trans)
            (setq indent-tabs-mode nil)))

;; (add-hook 'python-mode-hook
;;           '(lambda ()
;;              (outline-minor-mode 1)
;;              (setq
;;               tab-width 4
;;               python-indent 4
;;               outline-regexp py-outline-regexp
;;               outline-level 'py-outline-level)
;;              (local-set-key "\C-c\C-t" 'django-insert-transpy)))

;; pylookup configuration

(setq pylookup-dir "~/.emacs.d/pylookup")
(add-to-list 'load-path pylookup-dir)

(eval-when-compile (require 'pylookup))

(setq pylookup-program (concat pylookup-dir "/pylookup.py"))
(setq pylookup-db-file (concat pylookup-dir "/pylookup.db"))

;; set search option if you want
;; (setq pylookup-search-options '("--insensitive" "0" "--desc" "0"))

;; to speedup, just load it on demand
(autoload 'pylookup-lookup "pylookup"
  "Lookup SEARCH-TERM in the Python HTML indexes." t)

(autoload 'pylookup-update "pylookup"
  "Run pylookup-update and create the database at `pylookup-db-file'." t)

;; isearch configuration

(define-key isearch-mode-map (kbd "C-v") 'my-isearch-forward-to-beginning)
(defun my-isearch-forward-to-beginning ()
  "Do a forward search and jump to the beginning of the search-term."
  (interactive)
  (isearch-repeat 'forward)
  (goto-char isearch-other-end))

(defun my-isearch-forward ()
  "Do a forward search and jump to the beginning of the search-term."
  (interactive)
  (isearch-forward)
  (goto-char isearch-other-end))

(define-key isearch-mode-map (kbd "C-s") 'my-isearch-forward-to-beginning)
(define-key isearch-mode-map (kbd "C-v") 'isearch-repeat-forward)
(global-set-key (kbd "C-s") 'my-isearch-forward)

;; diff-hl

(require 'diff-hl)
(add-hook 'prog-mode-hook 'turn-on-diff-hl-mode)
(add-hook 'vc-dir-mode-hook 'turn-on-diff-hl-mode)

;; Emacs WebKit

;; (when (not (osx))
;;   (add-to-list 'load-path "/str/development/projects/open-source/.ghq/github.com/linuxdeepin/deepin-emacs/site-lisp/extensions/webkit/")
;;   (require 'webkit))

;; smerge mode

(autoload 'smerge-mode "smerge-mode" nil t)

(defun sm-try-smerge ()
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward "^<<<<<<< " nil t)
      (smerge-mode 1))))

(add-hook 'find-file-hook 'sm-try-smerge t)

;; column number mode

(column-number-mode 1)

;; detachable cursor - experimental package

;; (add-to-list 'load-path "/str/development/projects/open-source/elisp/dtc.el/")

;; sparky - experimental package

(add-to-list 'load-path (oo-elisp-path "sparky.el/"))

(require 'sparky)

(defun sparky-pre-cursor-color ()
  (setq curchg-default-cursor-color "red")
  (setq curchg-default-cursor-type 'hollow)
  (flet ((message (arg) nil))
    (toggle-cursor-type-when-idle nil)))

(defun sparky-post-cursor-color ()
  (setq curchg-default-cursor-color "light blue")
  (setq curchg-default-cursor-type 'bar)
  (flet ((message (arg) nil))
    (toggle-cursor-type-when-idle t)))

(add-hook 'sparky-enter-hook 'sparky-pre-cursor-color)
(add-hook 'sparky-quit-hook 'sparky-post-cursor-color)

(sparky--define-key sparky-mark-map "x" 'iregister-copy-to-register-kill)
(sparky--define-key sparky-mark-map "X" 'kill-region)

(sparky--define-key sparky-mark-forward-map "x" 'iregister-copy-to-register-kill)
(sparky--define-key sparky-mark-forward-map "X" 'kill-region)

(sparky--define-key sparky-mark-map "'"
                    (lambda ()
                      (interactive)
                      (if (region-active-p)
                          (er/expand-region 1)
                        (er/mark-inside-quotes))))

(sparky--define-key sparky-mark-map ")"
                    (lambda ()
                      (interactive)
                      (if (region-active-p)
                          (er/expand-region 1)
                        (er/mark-inside-pairs))))

;; (require 'dtc)
;; ;; (require 'dtc-experimental)
;; (require 'dtc-metad)
;; (require 'dtc-ck)
;; (require 'dtc-ca)
;; (require 'dtc-ce)
;; (require 'dtc-cd)
;; (require 'dtc-cs)

;; ;; (require 'dtc-nav)
;; (require 'dtc-mb)
;; (require 'dtc-mf)

;; (add-to-list 'load-path "/str/development/projects/open-source/elisp/cursor-mode.el/")

;; (require 'cursor-mode)
;; (require 'cursor-mode-ck)
;; (require 'cursor-mode-md)
;; (require 'cursor-mode-ca)
;; (require 'cursor-mode-ce)
;; (require 'cursor-mode-mb)
;; (require 'cursor-mode-mf)



;; disable brackets autocomplete
(setq skeleton-pair nil)

(defalias 'list-buffers 'ibuffer)

(when (not (osx))
  (load-file "~/.emacs.d/annot.el"))

(setq c-default-style "linux" c-basic-offset 4)
(add-hook 'c-mode-common-hook '(lambda () (c-toggle-auto-state 1)))

;; (add-to-list 'load-path (oo-elisp-path "ljupdate/"))
;; (require 'ljupdate)

(when (not (osx))
  (load-file "~/.emacs.d/ezbl.el")
  (require 'ezbl))

(autoload 'turn-on-eldoc-mode "eldoc" nil t)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)

; Don't show whitespace in diff, but show context
(setq vc-diff-switches '("-b" "-B" "-u"))

;; (load-file "/str/learning/elisp/ssh.el")
;; (setq tramp-default-method "ssh")

(setq c-basic-indent 2)
(setq tab-width 4)
(setq-default indent-tabs-mode nil)

(load-file (oo-elisp-path "emacs-request/request.el"))

(defun goto-project-root ()
  (interactive)
  (setq filename "/str/development/")
  (ido-set-current-directory filename)
  (setq ido-text "")
  (ido-set-current-directory (file-name-directory filename))
  (setq ido-exit 'refresh ido-text-init ido-text ido-rotate-temp t)
  (exit-minibuffer))

(define-key minibuffer-local-map (kbd "M-a") 'goto-project-root)

(defun online-syntax-highlight (beg end)
  (interactive (if (use-region-p)
                   (list (region-beginning) (region-end))
                 (list nil nil nil)))
  (let* ((code (buffer-substring-no-properties beg end)))
    (request
     "http://markup.su/api/highlighter"
     :type "POST"
     :data `(("source" . ,code)
             ("language" . ,(read-from-minibuffer "Language: "))
             ("theme" . "iPlastic"))
     :parser 'buffer-string
     :success
     (function* (lambda (&key data &allow-other-keys)
                  (when data
                    (with-current-buffer (current-buffer)
                      (insert data)))))
     :error
     (function* (lambda (&key error-thrown &allow-other-keys&rest _)
                  (message "Got error: %S" error-thrown)))
     :complete (lambda (&rest _) (message "Finished!")))))

(require 'moz)

(setq js-indent-level 2)

(defun javascript-moz-setup ()
  (moz-minor-mode 1))

;; Do not use gpg agent when runing in terminal
(defadvice epg--start (around advice-epg-disable-agent activate)
  (let ((agent (getenv "GPG_AGENT_INFO")))
    (when (not (display-graphic-p))
      (setenv "GPG_AGENT_INFO" nil))
    ad-do-it
    (when (not (display-graphic-p))
      (setenv "GPG_AGENT_INFO" agent))))

(load-file (oo-elisp-path "ukrainian-programmer-dvorak/ukrainian-programmer-dvorak.el"))

(setq default-input-method "ukrainian-programmer-dvorak")

(add-hook 'lisp-mode-hook
          (lambda ()
            (font-lock-add-keywords nil
                                    '(("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t)))))

; lisp-interaction-mode-hook

(when (not (osx))
  (add-to-list 'load-path "/usr/share/emacs/site-lisp/tex-utils")
  (require 'xdvi-search))

(setq org-cycle-emulate-tab 'white)

(load-file (oo-elisp-path "popup-el/popup.el"))

(require 'saveplace)
(setq-default save-place t)

(setq x-select-enable-clipboard t
      x-select-enable-primary t
      save-interprogram-paste-before-kill t
      apropos-do-all t
      mouse-yank-at-point t
      save-place-file (concat user-emacs-directory "places")
      backup-directory-alist `(("." . ,(concat user-emacs-directory
                                               "backups"))))

(defun @tail()
  (interactive)
  (let ((filepath
         (concat ido-current-directory
                 (ido-name (car ido-matches)))))
    (make-comint-in-buffer "Log" "*Log*" "tail" nil "-f" filepath))
  (pop-to-buffer "*Log*"))

(define-key minibuffer-local-map (kbd "M-t") '@cisco/tail)

(add-to-list 'load-path "~/mh-e-8.5/")

(require 'gnus-dired)

;; make the `gnus-dired-mail-buffers' function also work on
;; message-mode derived modes, such as mu4e-compose-mode
(defun gnus-dired-mail-buffers ()
  "Return a list of active message buffers."
  (let (buffers)
    (save-current-buffer
      (dolist (buffer (buffer-list t))
        (set-buffer buffer)
        (when (and (derived-mode-p 'message-mode)
                   (null message-sent-message-via))
          (push (buffer-name buffer) buffers))))
    (nreverse buffers)))

(setq gnus-dired-mail-mode 'mu4e-user-agent)
(add-hook 'dired-mode-hook 'turn-on-gnus-dired-mode)

(defun nose-run-test ()
  (interactive)
  (save-buffer)
  (nosetests-module))

(defun @import (import)
  (interactive "sImport: ")
  (let ((pos (point)))
    (goto-char (point-min))
    (insert (format "%s\n" import))
    (goto-char pos)))

;; source: http://stackoverflow.com/questions/7937395/select-the-previously-selected-window-in-emacs/
(defun switch-to-previous-buffer-possibly-creating-new-window ()
  (interactive)
  (pop-to-buffer (other-buffer (current-buffer) t)))

;; source: http://stackoverflow.com/questions/7937395/select-the-previously-selected-window-in-emacs/
(defun switch-to-the-window-that-displays-the-most-recently-selected-buffer ()
  (interactive)
  (let* ((buflist (buffer-list (selected-frame)))      ; get buffer list in this frames ordered
         (buflist (delq (current-buffer) buflist))     ; if there are multiple windows showing same buffer.
         (winlist (mapcar 'get-buffer-window buflist)) ; buf->win
         (winlist (delq nil winlist))                  ; remove non displayed windows
         (winlist (delq (selected-window) winlist)))   ; remove current-window
    (if winlist
        (select-window (car winlist))
      (message "Couldn't find a suitable window to switch to"))))

(global-set-key (kbd "C-c m") 'message-mark-inserted-region)

(define-key minibuffer-local-completion-map (kbd "SPC") 'minibuffer-complete-and-exit)

(winner-mode 1)

;; Make backups of files, even when they're in version control
(setq vc-make-backup-files t)

(defun my-argument-fn (switch)
  (message "i was passed -my_argument"))

(add-to-list 'command-switch-alist '("-my_argument" . my-argument-fn))

(global-set-key (kbd "H-;") 'eshell)

(defun my-argument-fn (switch)
  (print "i was passed -myarg")
  (kill-emacs))

(add-to-list 'command-switch-alist '("-myarg" . my-argument-fn))
(put 'narrow-to-region 'disabled nil)
(put 'set-goal-column 'disabled nil)

(global-auto-revert-mode)
(put 'downcase-region 'disabled nil)

(setq max-mini-window-height 0.5)
(put 'upcase-region 'disabled nil)

(global-set-key (kbd "H-SPC") 'hippie-expand)

(add-to-list 'load-path (oo-ghq-path "code.google.com/p/emacs-soap-client/"))
(require 'soap-client)
(setq jiralib-url "https://qbeats.atlassian.net/")

(add-to-list
 'directory-abbrev-alist
 '("^/gt" . (oo-elisp-path "google-translate")))

(define-abbrev-table 'my-tramp-abbrev-table
  '(("gt" (oo-elisp-path "google-translate"))))

(add-hook
 'minibuffer-setup-hook
 (lambda ()
   (abbrev-mode 1)
   (setq local-abbrev-table my-tramp-abbrev-table)))

(defadvice minibuffer-complete
  (before my-minibuffer-complete activate)
  (expand-abbrev))

;; If you use partial-completion-mode
(defadvice PC-do-completion
  (before my-PC-do-completion activate)
  (expand-abbrev))

(add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)
(add-hook 'css-mode-hook #'aggressive-indent-mode)

(defun narrow-or-widen-dwim (p)
  "If the buffer is narrowed, it widens. Otherwise, it narrows intelligently.
Intelligently means: region, org-src-block, org-subtree, or defun,
whichever applies first.
Narrowing to org-src-block actually calls `org-edit-src-code'.

With prefix P, don't widen, just narrow even if buffer is already
narrowed."
  (interactive "P")
  (declare (interactive-only))
  (cond ((and (buffer-narrowed-p) (not p)) (widen))
        ((region-active-p)
         (narrow-to-region (region-beginning) (region-end)))
        ((derived-mode-p 'org-mode)
         ;; `org-edit-src-code' is not a real narrowing command.
         ;; Remove this first conditional if you don't want it.
         (cond ((ignore-errors (org-edit-src-code))
                (delete-other-windows))
               ((org-at-block-p)
                (org-narrow-to-block))
               (t (org-narrow-to-subtree))))
        (t (narrow-to-defun))))

;; (define-key endless/toggle-map "n" #'narrow-or-widen-dwim)
;; This line actually replaces Emacs' entire narrowing keymap, that's
;; how much I like this command. Only copy it if that's what you want.
(define-key ctl-x-map "n" #'narrow-or-widen-dwim)

;; (when (osx)
;;   (set-default-font "-*-Source Code Pro-light-normal-normal-*-20-*-*-*-m-0-iso10646-1")
;;   ;; (add-to-list 'default-frame-alist '(font . "Source Code Pro-22"))
;;   (add-to-list 'default-frame-alist '(font . "Source Code Pro-iso10646-0-light-20")))

(when (osx)
  (set-face-attribute 'default nil :family "Source Code Pro")
  (set-face-attribute 'default nil :height 200)
  (set-face-attribute 'default nil :weight 'light))
