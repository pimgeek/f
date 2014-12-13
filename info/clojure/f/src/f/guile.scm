#!/usr/bin/guile
!#

(define atom?
 (lambda (x)
    (and (not (pair? x)) (not (null? x)))))

(define lat?
  (lambda (l)
    (cond
      ((null? l) #t)
      ((atom? (car l)) (lat? (cdr l)))
      (else #f))))

(atom? 'a)
(atom? '())
(atom? '(a b))
; (lat? 'a)
(lat? '())
(lat? '(a b))
(lat? '(a (b)))
