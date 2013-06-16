#lang r5rs

(define perf-tbl 
  '(
    ("apple" 1 3 3) 
    ("banana" 4 2 4) 
    ("cabbage" 5 2 3) 
    ("rice" 6 3 5)
    ("noodle" 3 1 4)
    ("tomato" 2 5 1)
    )
  )
(define map-tbl 
  '(
    ("apple" "fruit") 
    ("bread" "main food")
    ("cabbage" "vegetable")
    ("banana" "fruit")
    ("beef" "meat")
    ("noodle" "main food")
    ("tomato" "vegetable")
    )
  )
(define atom? 
  (lambda (input)
    (cond ((null? input) '#f)
          ((list? input) '#f)
          (else '#t)
          )
    )
  )
(define firsts 
  (lambda (lol)
    (cond ((null? lol) '())
          ((atom? lol) '())
          (else (cons 
                 (car (car lol)) 
                 (firsts (cdr lol)))
                )
          )
    )
  )
(display perf-tbl)
(newline)
(display map-tbl)
(newline)
(firsts perf-tbl)
(newline)
(firsts map-tbl)
