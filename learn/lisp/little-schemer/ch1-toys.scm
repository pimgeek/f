#!/usr/bin/racket

# atom

'atom

'turkey

1942

'u

'*abc$

# list

'(atom)

'(atom turkey or)

'(atom turkey) or

'((atom turkey) or)

# s-exp

'xyz

'(x y z)

'((x y) z)

'(how are you doing so far)

'(((how) are) ((you) (doing so)) far)

'()

'(() () () ())

# car of list 

(car '(a b c))

(car '(((hotdogs)) (and) (pickle) relish))

(car (car '(((hotdogs)) (and))))

# cdr of list

(cdr '(a b c))

(cdr '((a b c) x y z))

(cdr '(hamburger))

(cdr '((x) t r))

(cdr 'hotdogs)

(cdr '())

# car and cdr

(car (cdr '((b) (x y) ((c)))))

(cdr (cdr '((b) (x y) ((c)))))

(cdr (car (a (b (c)) d)))




