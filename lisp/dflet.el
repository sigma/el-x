;;; dflet.el --- dynamically-scoped flet

;; Copyright (C) 2012  Yann Hodique

;; Author: Yann Hodique <yann.hodique@gmail.com>
;; Keywords: lisp

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; This is bringing back the historical definition of `flet', in all its global
;; and dynamic splendor.

;;; Code:

(eval-when-compile
  (require 'cl)
  (require 'macroexp)
  (require 'subr-compat))

(if (version< emacs-version "24.3")
    ;; before that version, flet was not marked as obsolete, so use it
    (defalias 'dflet 'flet)

  ;; This should really have some way to shadow 'byte-compile properties, etc.
  (defmacro dflet (bindings &rest body)
    "Make temporary overriding function definitions.
This is an analogue of a dynamically scoped `let' that operates on the function
cell of FUNCs rather than their value cell.

\(fn ((FUNC ARGLIST BODY...) ...) FORM...)"
    (declare (indent 1) (debug cl-flet))
    `(cl-letf ,(mapcar
                (lambda (x)
                  (list
                   (list 'symbol-function (list 'quote (car x)))
                   (cons 'lambda (cons (cadr x) (cddr x)))))
                bindings)
       ,@body)))

;;;###autoload
(autoload 'dflet "dflet")

(provide 'dflet)
;;; dflet.el ends here
