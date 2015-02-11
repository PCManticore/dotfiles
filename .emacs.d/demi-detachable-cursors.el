(defvar decur/cursor nil "Overlay for cursor.")

(defface decur/cursor-face
  '(;; (t (:inverse-video t))
    ;; (((class color) (min-colors 16) (background light))
    ;;  :background "darkseagreen2")
    (((class color) (min-colors 8))
     :background "green" :foreground "black")
    )
  "The face used for fake cursors"
  :group 'decur)

(defun decur/test ()
  (interactive)
  (let ((repeat-key (event-basic-type last-input-event))
        (bindings (list "-" "-"))
        (msg "Test message"))
    (when t
      (set-temporary-overlay-map 
       (let ((map (make-sparse-keymap)))
         (dolist (binding bindings map)
           (define-key map (read-kbd-macro "-")
             `(lambda ()
                (interactive)
                (setq this-command `,(cadr ',binding))
                (or (minibufferp) (message "%s" ,msg))
                (eval `,(cdr ',binding))))))
       t)
      (or (minibufferp) (message "%s" msg)))))

(defun decur/test2 ()
  (interactive)
  (set-temporary-overlay-map decur-mode-map))

(defun decur/move-overlay (expr &optional move-cursor)
  (interactive)
  (set-temporary-overlay-map decur-mode-map)
  (let ((new-pos nil))
    (dolist (overlay (list decur/cursor))
      (save-excursion
        (goto-char
         (overlay-start overlay))
        (eval expr)
        (move-overlay overlay (point) (+ (point) 1))
        (setq new-pos (point)))
      (when move-cursor
        (goto-char new-pos)))))

(defun decur/new-line-below ()
  (interactive)
  (goto-char (line-end-position))
  (newline)
  (decur/attach-all))

(defun decur/new-line-above ()
  (interactive)
  (forward-line -1)
  (goto-char (line-end-position))
  (newline)
  (decur/attach-all))

(defun decur/delete-line ()
  (interactive)
  (goto-char (line-beginning-position))
  (kill-line)
  (kill-line))

(defun decur/goto-eol ()
  (interactive)
  (goto-char (line-end-position))
  (decur/attach-all))

(defun decur/forward-word ()
  (interactive)
  (decur/move-overlay '(forward-word)))

(defun decur/backward-word ()
  (interactive)
  (decur/move-overlay '(forward-word -1)))

(defun decur/occurrence-of-char-to-the-right (char)
  (interactive "cInput character: ")
  (decur/move-overlay '(search-forward (char-to-string char))))

(defun decur/forward-word-alt ()
  (interactive)
  (decur/move-overlay '(forward-word) t))

(defun decur/backward-word-alt ()
  (interactive)
  (decur/move-overlay '(forward-word -1) t))

(defun decur/next-line ()
  (interactive)
  (decur/move-overlay '(next-line)))

(defun decur/previous-line ()
  (interactive)
  (decur/move-overlay '(previous-line)))

(defun decur/forward-char ()
  (interactive)
  (decur/move-overlay '(forward-char)))

(defun decur/backward-char ()
  (interactive)
  (decur/move-overlay '(backward-char)))

(defun decur/forward-sexp ()
  (interactive)
  (decur/move-overlay '(forward-sexp)))

(defun decur/backward-sexp ()
  (interactive)
  (decur/move-overlay '(backward-sexp)))

(defvar decur-mode-map
  (let ((map (make-sparse-keymap)))
    ;; (set-keymap-parent map parent-mode-shared-map)
    (suppress-keymap map)
    (define-key map (kbd "C-c C-c") 'decur/test-output)
    (define-key map (kbd "o") 'decur/new-line-below)
    (define-key map (kbd "O") 'decur/new-line-above)
    ;; (define-key map (kbd "w") 'decur/forward-word)
    ;; (define-key map (kbd "M-w") 'decur/forward-word-alt)
    ;; (define-key map (kbd "b") 'decur/backward-word)
    ;; (define-key map (kbd "M-b") 'decur/backward-word-alt)
    (define-key map (kbd "dd") 'decur/delete-line)
    (define-key map (kbd "cc") 'decur/test-output)
    (define-key map (kbd "$") 'decur/goto-eol)
    ;; (define-key map (kbd "f") 'decur/occurrence-of-char-to-the-right)
    ;; (define-key map (kbd "n") 'decur/next-line)
    (define-key map [remap next-line] 'decur/next-line)
    (define-key map [remap previous-line] 'decur/previous-line)
    (define-key map [remap forward-char] 'decur/forward-char)
    (define-key map [remap backward-char] 'decur/backward-char)
    (define-key map [remap forward-word] 'decur/forward-word)
    (define-key map [remap backward-word] 'decur/backward-word)
    (define-key map [remap forward-sexp] 'decur/forward-sexp)
    (define-key map [remap backward-sexp] 'decur/backward-sexp)
    (define-key map "n" 'decur/next-line)
    (define-key map "p" 'decur/previous-line)
    (define-key map "f" 'decur/forward-char)
    (define-key map "F" 'decur/backward-char)
    (define-key map "b" 'decur/backward-char)
    (define-key map "q" 'decur/attach-all)
    ;; (define-key map (kbd "C-n") 'decur/next-line)
    ;; (define-key map (kbd "C-p") 'decur/previous-line)
    ;; (define-key map (kbd "C-f") 'decur/forward-char)
    ;; (define-key map (kbd "C-b") 'decur/backward-char)
    map))

(define-minor-mode decur-minor-mode
  "Get your foos in the right places."
  :lighter " decur-minor-mode"
  :keymap decur-mode-map)

(define-derived-mode decur-major-mode fundamental-mode
  (setq mode-name "decur-major-mode")
  )

(define-key decur-major-mode-map (kbd "n") 'decur/next-line)
(define-key decur-major-mode-map (kbd "p") 'decur/previous-line)
(define-key decur-major-mode-map (kbd "f") 'decur/forward-char)
(define-key decur-major-mode-map (kbd "u") 'decur/backward-char)

(defun decur/make-cursor-overlay-at-eol (pos)
  "Create overlay to look like cursor at end of line."
  (let ((overlay (make-overlay pos pos nil nil nil)))
    (overlay-put overlay
                 'after-string (propertize " " 'face 'decur/cursor-face))
    overlay))

(defun decur/make-cursor-overlay-inline (pos)
  "Create overlay to look like cursor inside text."
  (let ((overlay (make-overlay pos (1+ pos) nil nil nil)))
    (overlay-put overlay 'face 'decur/cursor-face)
    overlay))

(defun decur/make-cursor (map &optional display)
  "Create overlay to look like cursor.
Special case for end of line, because overlay over a newline
highlights the entire width of the window."
  (interactive)
  (let ((overlay nil))
    (setq overlay (if (eolp)
                      (decur/make-cursor-overlay-at-eol (point))
                    (decur/make-cursor-overlay-inline (point))))
    (overlay-put overlay 'keymap map)
    (overlay-put overlay 'tag 'decur)
    (when display
      (overlay-put decur/cursor 'display display))))

(defun decur/detach ()
  (interactive)
  (set-temporary-overlay-map decur-mode-map)
  (setq decur/cursor (decur/make-cursor)))

(defun decur--detach (map &optional display)
  (set-temporary-overlay-map map)
  (setq decur/cursor (decur/make-cursor map display)))

(defun decur-detach-vim-cursor ()
  (interactive)
  (decur--detach vim-keymap "v"))

(defun decur/detach-to-defun ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "(defun" nil t nil)
      (goto-char (- (point) 6))
      (decur/detach)
      (goto-char (+ (point) 1)))))

(defun decur/attach ()
  (interactive)
  (delete-overlay decur/cursor)
  (setq decur/cursor nil)
  ;; (decur-minor-mode -1)
  ;; (dolist (overlay (car (overlay-lists)))
  ;;   (when (eq (overlay-get overlay 'tag) 'decur)
  ;;     (setq ov-start (overlay-start overlay))
  ;;     (when (eq (overlay-start overlay) (point))
  ;;       (delete-overlay overlay))))
  )

(defun decur/attach-all ()
  (interactive)
  ;; (decur-minor-mode -1)
  (delete-overlay decur/cursor)
  (setq decur/cursor nil)
  ;; (dolist (overlay (overlays-in (point-min) (point-max)))
  ;;   (when (eq (overlay-get overlay 'tag) 'decur)
  ;;     (delete-overlay overlay)))
  )

(defun decur/switch-to-next ()
  (interactive)
  (let ((max-position (point-max))
        (point (point))
        (ov-start nil))
    (dolist (overlay (car (overlay-lists)))
      (when (eq (overlay-get overlay 'tag) 'decur)
        (setq ov-start (overlay-start overlay))
        (when (and (> ov-start point)
                   (< ov-start max-position))
          (setq max-position ov-start))))
    (goto-char max-position)))

(defun decur/switch-to-previous ()
  (interactive)
  (let ((min-position 0)
        (point (point))
        (ov-start nil))
    (dolist (overlay (car (overlay-lists)))
      (when (eq (overlay-get overlay 'tag) 'decur)
        (setq ov-start (overlay-start overlay))
        (when (and (< ov-start point)
                   (> ov-start min-position))
          (setq min-position ov-start))))
    (goto-char min-position)))


(when (not (fboundp 'set-temporary-overlay-map))
  ;; Backport this function from newer emacs versions
  (defun set-temporary-overlay-map (map &optional keep-pred)
    "Set a new keymap that will only exist for a short period of time.
The new keymap to use must be given in the MAP variable. When to
remove the keymap depends on user input and KEEP-PRED:

- if KEEP-PRED is nil (the default), the keymap disappears as
  soon as any key is pressed, whether or not the key is in MAP;

- if KEEP-PRED is t, the keymap disappears as soon as a key *not*
  in MAP is pressed;

- otherwise, KEEP-PRED must be a 0-arguments predicate that will
  decide if the keymap should be removed (if predicate returns
  nil) or kept (otherwise). The predicate will be called after
  each key sequence."

    (let* ((clearfunsym (make-symbol "clear-temporary-overlay-map"))
           (overlaysym (make-symbol "t"))
           (alist (list (cons overlaysym map)))
           (clearfun
            `(lambda ()
               (unless ,(cond ((null keep-pred) nil)
                              ((eq t keep-pred)
                               `(eq this-command
                                    (lookup-key ',map
                                                (this-command-keys-vector))))
                              (t `(funcall ',keep-pred)))
                 (remove-hook 'pre-command-hook ',clearfunsym)
                 (setq emulation-mode-map-alists
                       (delq ',alist emulation-mode-map-alists))))))
      (set overlaysym overlaysym)
      (fset clearfunsym clearfun)
      (add-hook 'pre-command-hook clearfunsym)

      (push alist emulation-mode-map-alists))))


(provide 'demi-detachable-cursors)
