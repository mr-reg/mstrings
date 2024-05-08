;;; mstrings.el - Support for the Common Lisp mstrings library in the Emacs lisp-mode
;;;
;;; Copyright (C) 2024 by Gleb Borodulia
;;; Author: Gleb Borodulia <mr.reg@mail.ru>
;;;
;;; BSD 3-Clause License. See LICENSE for details.

(require 'lisp-mode)
(defun cl-mstring-indent (orig-fun &rest args)
  (let ((parse-start (car args))
        column)
    (when (and (listp parse-start) (nth 3 parse-start))
      ;; we are inside string
      (let* ((string-start (nth 8 parse-start))
             (prefix (buffer-substring-no-properties (max 0 (- string-start 2)) string-start)))
        (when (string= prefix "#M")
          (let ((original-point (point)))
            (goto-char string-start)
            (setq column (1+ (current-column)))
            (goto-char original-point)))))
    (or column (apply orig-fun args))))

(advice-add 'calculate-lisp-indent :around 'cl-mstring-indent)
(provide 'mstrings)
