;; Dirichlet distribution
;; Liam Healy, Sun Oct 29 2006
;; Time-stamp: <2012-01-13 12:01:22EST dirichlet.lisp>
;;
;; Copyright 2006, 2007, 2008, 2009, 2011 Liam M. Healy
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

(in-package :gsl)

;;; /usr/include/gsl/gsl_randist.h

(defmfun sample
    ((generator random-number-generator) (type (eql :dirichlet))
     &key alpha (theta (vdf (dim0 alpha))))
  "gsl_ran_dirichlet"
  (((mpointer generator) :pointer)
   ((dim0 alpha) :sizet)
   ((grid:foreign-pointer alpha) :pointer)
   ;; theta had better be at least as long as alpha, or they'll be trouble
   ((grid:foreign-pointer theta) :pointer))
  :definition :method
  :inputs (alpha)
  :outputs (theta)
  :c-return :void
  :return (theta)
  :documentation			; FDL
  "An array of K=(length alpha) random variates from a Dirichlet
  distribution of order K-1.  The distribution function is
  p(\theta_1,\ldots,\theta_K) \, d\theta_1 \cdots d\theta_K = 
        {1 \over Z} \prod_{i=1}^{K} \theta_i^{\alpha_i - 1} 
          \; \delta(1 -\sum_{i=1}^K \theta_i) d\theta_1 \cdots d\theta_K
  theta_i >= 0 and alpha_i >= 0.
  The delta function ensures that \sum \theta_i = 1.
  The normalization factor Z is
  Z = {\prod_{i=1}^K \Gamma(\alpha_i) \over \Gamma( \sum_{i=1}^K \alpha_i)}
  The random variates are generated by sampling K values 
  from gamma distributions with parameters a=alpha_i, b=1, 
  and renormalizing. 
  See A.M. Law, W.D. Kelton, \"Simulation Modeling and Analysis\"
  (1991).")

(defmfun dirichlet-pdf (alpha theta)
  "gsl_ran_dirichlet_pdf"
  (((dim0 alpha) :sizet)
   ((grid:foreign-pointer alpha) :pointer)
   ;; theta had better be at least as long as alpha, or they'll be trouble
   ((grid:foreign-pointer theta) :pointer))
  :inputs (alpha theta)
  :c-return :double
  :documentation			; FDL
  "The probability density p(\theta_1, ... , \theta_K)
   at theta[K] for a Dirichlet distribution with parameters 
   alpha[K], using the formula given for #'sample :dirichlet.")

(defmfun dirichlet-log-pdf (alpha theta)
  "gsl_ran_dirichlet_lnpdf"
  (((dim0 alpha) :sizet)
   ((grid:foreign-pointer alpha) :pointer)
   ;; theta had better be at least as long as alpha, or they'll be trouble
   ((grid:foreign-pointer theta) :pointer))
  :inputs (alpha theta)
  :c-return :double
  :documentation			; FDL
  "The logarithm of the probability density 
   p(\theta_1, ... , \theta_K)
   for a Dirichlet distribution with parameters 
   alpha[K].")

;;; Examples and unit test
(save-test dirichlet
 (let ((rng (make-random-number-generator +mt19937+ 0))
       (alpha #m(1.0d0 2.0d0 3.0d0 4.0d0)))
   (grid:copy-to (sample rng :dirichlet :alpha alpha)))
 (let ((alpha #m(1.0d0 2.0d0 3.0d0 4.0d0))
       (theta #m(1.0d0 2.0d0 3.0d0 4.0d0)))
   (dirichlet-pdf alpha theta))
 (let ((alpha #m(1.0d0 2.0d0 3.0d0 4.0d0))
       (theta #m(1.0d0 2.0d0 3.0d0 4.0d0)))
   (dirichlet-log-pdf alpha theta)))



