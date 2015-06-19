;; Methods for lisp-unit functions
;; Liam Healy 2010-08-22 19:10:26EDT lisp-unit-extension.lisp
;; Time-stamp: <2010-08-22 19:11:27EDT lisp-unit-extension.lisp>

(in-package :lisp-unit)

(defmethod norm-equal
    ((data1 grid:foreign-array) (data2 grid:foreign-array)
     &optional (epsilon *epsilon*) (measure *measure*))
  (norm-equal (grid:copy-to data1) (grid:copy-to data2)
	      epsilon measure))
