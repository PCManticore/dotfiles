;;; === screenshot method
;;; --------------------------------------------------------------
;; We will specify the directory that the image is stored. The string of
;; directory is stored in the file d-sikuli/pipe-file. To spicify
;; d-sikuli/pipe-file we use the function d-sikuli/setImageDir.
;;
;; There is screenshot_sikuli.sh. The script will execute 'emacs --batch
;; --eval ...' to get newly generated image file name. The script uses the
;; function d-sikuli/getImageName to get new image filename.

(defvar d-sikuli/pipe-file "/Users/atykhonov/projects/sikuli/screenshot_sikuli.txt")

(defun d-sikuli/setImageDir (&optional dirname)
  (interactive)
  (setq dirname (read-directory-name "Directory: " default-directory))
  (save-excursion
    (find-file d-sikuli/pipe-file)
    (erase-buffer)
    ;; scrot requires absolute path
    (insert (expand-file-name dirname))
    (save-buffer)
    (kill-buffer)))

(defun d-sikuli/getImageName ()
  (let* ((dirname (d-sikuli/getDirName))
         (new-number (+ 1 (d-libs-image/maxNumber dirname))))
    (concat dirname "image" (number-to-string new-number) ".png")))

(defun d-sikuli/getDirName ()
  (let* (content)
    (save-excursion

      (find-file d-sikuli/pipe-file)
      (goto-char (point-min))
      (setq content (buffer-substring
                     (progn
                       (beginning-of-line)
                       (point))
                     (progn
                       (end-of-line)
                       (point))))
      (kill-buffer)
      )
    content))

;;; === Image shower in python-mode
;;; --------------------------------------------------------------
;; It is more convenient to see screen capture icons during write sikuli
;; script in emacs. The name of images to be captured has the regexp
;; 'image[0-9]\\.png'. The function d-sikuli/showImage will the image
;; directly in the buffer. It also toggle the images.

(defvar d-sikuli/show-image-p nil)

(defun d-sikuli/showImage ()
  "Toggle images. The name of image has the form 'image[0-9]\\.png'"
  (interactive)
  (if d-sikuli/show-image-p
      (progn
        ;; TODO: Separate this to d-sikuli/toggleImage
        (setq d-sikuli/show-image-p nil)
        (d-sikuli/removeImage))

    (progn (make-local-variable 'd-sikuli/show-image-p)
           (setq d-sikuli/show-image-p t)

           (let* ((position-lists (d-sikuli/imagePositionAlist))
                  element
                  name
                  start)
             (message "Position Lists: %s" position-lists)
             (while position-lists
               (setq element (car position-lists))
               (setq position-lists (cdr position-lists))
               (setq name (car element))
               (setq start (cdr element))
               (d-sikuli/putImage name start)
               )))))

(defun d-sikuli/toggleImage ()
  (interactive)
  (d-sikuli/showImage))

(defun d-sikuli/reflashImage ()
  (interactive)
  (d-sikuli/toggleImage)
  (d-sikuli/toggleImage))


(defun d-sikuli/removeImage ()
  (interactive)
  (remove-images (point-min) (point-max)))

(defun d-sikuli/putImage (name start)
  (let* ((full-name (concat (d-sikuli/getDirName) name))
         (img-dsc (create-image full-name))
         )
    (message "Full Name: %s" full-name)
    (message "Image Description: %s" img-dsc)
    (put-image img-dsc (- start 1))))

(defun d-sikuli/imagePositionAlist ()
  (interactive)
  ;; (image_name start)
  (let* (lists
         element
         name
         start)
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "[0-9]+\\.png" nil t)
        (setq name (match-string 0))
        (setq start (match-beginning 0))
        (setq element (cons name start))
        (setq lists (cons element lists))))
    lists))
