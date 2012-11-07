#lang racket/gui

(require racket/gui/base)

; Make a frame by instantiating the frame% class
(define frame (new frame% 
                   [label "hello"]
                   [width 300]
                   [height 300]))

; Show the frame by calling its show method
(send frame show #t)

; get label text from user
(define lbl (get-text-from-user "f-pim"
                    "test text"
                    frame
                    #:validate string?))

; set new label to the frame
(send frame set-label lbl)

; make the new label effective
(send frame refresh)