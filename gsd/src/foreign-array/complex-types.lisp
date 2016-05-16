;; Complex number types
;; Liam Healy 2009-01-13 21:24:05EST complex-types.lisp
;; Time-stamp: <2010-11-27 21:35:43EST complex-types.lisp>
;;
;; Copyright 2009, 2010 Liam M. Healy
;; Distributed under the terms of the GNU General Public License
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(in-package :grid)

(export '(complex-double-c complex-float-c component-float-type component-type))

;;;;****************************************************************************
;;;; Complex types
;;;;****************************************************************************

#+fsbv
(fsbv:defcstruct
    (complex-float-c :constructor complex :deconstructor (realpart imagpart))
  (dat :float :count 2))

#-fsbv
(cffi:defcstruct complex-float-c (dat :float :count 2))

#+fsbv
(fsbv:defcstruct
    (complex-double-c :constructor complex :deconstructor (realpart imagpart))
  (dat :double :count 2))

#-fsbv
(cffi:defcstruct complex-double-c (dat :double :count 2))

#+long-double
(cffi:defcstruct complex-long-double-c
  (dat :long-double :count 2))

#|
;;; If this can be made a macro that is setfable, it can be used to
;;; replace the direct call to fsbv:object in dereference-complex.
(defmacro complex-to-cl (pointer &optional (complex-type 'complex-double-c) (index 0))
  "Get the complex number from the foreign pointer to Lisp."
  #+fsbv `(fsbv:object ,pointer ,complex-type)
  #-fsbv
  ;; Ported from fsbv:foreign-object-components form from
  ;; macroexpansion of fsbv:defstruct, for use when FSBV is not
  ;; available.
  (let ((ptr `(cffi:mem-aref ,pointer ,complex-type ,index))
	(comptype
	 (component-type
	  `(complex ,(if (eql complex-type 'complex-double-c)
			 'double-float
			 'single-float)))))
    (complex
     (cffi:mem-aref
      (cffi:foreign-slot-value ptr complex-type 'dat)
      comptype 0)
     (cffi:mem-aref
      (cffi:foreign-slot-value ptr complex-type 'dat)
      comptype 1))))
|#

(defun clean-type (type)
  ;; SBCL (and possibly other implementations) specifies limits on the type, e.g.
  ;; (type-of #C(1.0 2.0))
  ;; (COMPLEX (DOUBLE-FLOAT 1.0 2.0))
  ;; This cleans that up to make
  ;; (clean-type (type-of #C(1.0 2.0)))
  ;; (COMPLEX DOUBLE-FLOAT)
  (if (and (subtypep type 'complex) (listp (second type)))
      (list (first type) (first (second type)))
      type))

(defun component-float-type (eltype)
  "The type of the component of this type (complex)."
  (if (subtypep eltype 'complex)
      ;; complex: use the component type
      (second eltype)
      eltype))

(defun component-type (eltype)
  (cl-cffi (component-float-type eltype)))

