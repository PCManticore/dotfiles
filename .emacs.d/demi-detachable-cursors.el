
(defface decur/cursor-face
  '((t (:inverse-video t)))
  "The face used for fake cursors"
  :group 'decur)

(defun decur/make-cursor-overlay-inline (pos)
  "Create overlay to look like cursor inside text."
  (let ((overlay (make-overlay pos (1+ pos) nil nil nil)))
    (overlay-put overlay 'face 'decur/cursor-face)
    (overlay-put overlay 'tag 'decur)
    overlay))

(defun decur/make-cursor-overlay-at-eol (pos)
  "Create overlay to look like cursor at end of line."
  (let ((overlay (make-overlay pos pos nil nil nil)))
    (overlay-put overlay 'after-string (propertize " " 'face 'decur/cursor-face))
    (overlay-put overlay 'tag 'decur)
    overlay))

(defun decur/detach ()
  "Create overlay to look like cursor.
Special case for end of line, because overlay over a newline
highlights the entire width of the window."
  (interactive)
  (if (eolp)
      (decur/make-cursor-overlay-at-eol (point))
    (decur/make-cursor-overlay-inline (point))))

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
  (dolist (overlay (car (overlay-lists)))
    (when (eq (overlay-get overlay 'tag) 'decur)
      (setq ov-start (overlay-start overlay))
      (when (eq (overlay-start overlay) (point))
        (delete-overlay overlay)))))

(defun decur/attach-all ()
  (interactive)
  (dolist (overlay (overlays-in (point-min) (point-max)))
    (when (eq (overlay-get overlay 'tag) 'decur)
      (delete-overlay overlay))))

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


(provide 'demi-detachable-cursors)
