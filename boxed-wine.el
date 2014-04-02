;;; boxed-wine.el --- Boxed Wine: Manage your Emacs config with Boxen & Cask

;; Copyright © 2014 Tim Taylor

;; Author: Tim Taylor <tim@tool-man.org>
;; Maintainer: Tim Taylor <tim@tool-man.org>
;; Version: 0.0.1
;; Keywords: convenience
;; URL: https://github.com/toolbear/boxed-wine
;; License: MIT

;; This file is NOT part of GNU Emacs.

;;; License:

;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the "Software"), to deal
;; in the Software without restriction, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:

;; The above copyright notice and this permission notice shall be included in
;; all copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
;; THE SOFTWARE.

;;; Code:

(defun boxed-wine--load-user-customizations ()
  "Load all customizations in `~/.emacs.d/CURRENT-USER'.

Loading messages are suppressed. Skips `custom.el'."
  (when (file-exists-p current-user-dir)
    (dolist (file-name (directory-files current-user-dir 't "^[^.#].*\\.el$"))
      (when (not (string-match-p "/custom\\.el$" file-name))
        (load file-name nil 't)))))

(defun boxed-wine--find-custom-themes ()
  (dolist (dir (boxed-wine--find-theme-dirs theme-dir))
    (add-to-list 'custom-theme-load-path dir)))

(defun boxed-wine--find-theme-dirs (parent)
  "Recursively find directories containing themes under DIR."
  (let (matches)
    (cond
     ((not (file-directory-p parent)))

     ((directory-files parent nil "^[^.#].*-theme\.el$" 't) (list parent))

     (t (dolist (d (directory-files parent 't "^[^.#]" 't))
          (setq matches (append (boxed-wine--find-theme-dirs d) matches)))
        matches))))

;;;###autoload
(defun boxed-wine-initialize ()
  (let* ((current-user     (getenv "USER"))
         (current-user-dir (expand-file-name (format "%s.d" current-user) user-emacs-directory))
         (theme-dir        (expand-file-name "themes" user-emacs-directory)))
    (boxed-wine--find-custom-themes)
    (boxed-wine--load-user-customizations)
    (setq custom-file (expand-file-name "custom.el" current-user-dir))))

(provide 'boxed-wine)

;;; boxed-wine.el ends here
