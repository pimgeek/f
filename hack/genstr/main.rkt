#!/usr/bin/racket

; 把一个以字符串为元素的列表转化为一个单独的字符串
(define (strlst-to-str strlst)
  (apply string-append strlst))

; 把一个列表中的元素逐一抽取出来，形成全排列 
; 这个函数是 racket 自带的
; (permutation '(a b))

; 给定一个元素和一个列表，从列表中移除第一个
; 与该元素相同的元素，返回剩余元素的列表
; 这个函数是 racket 自带的
; (remove 'a '(a b a c))

; 从给定列表中随机取出一个元素
(define (random-pick lst)
  (list-ref
    lst (random (length lst))))

; 从给定列表中随机取出 n 个元素，并且要求每次取出元素
; 所在的位置都不重复
(define (random-pick-n lst n)
  (cond
    ([= n 0] '())
    ([= n 1] (list (random-pick lst)))
    (else    (let*
               ([picked (random-pick lst)]
                [newlst (remove picked lst)])
               (cons picked
                 (random-pick-n newlst (- n 1)))))))

; 定义一些有趣的字符串
(define candid-strlst
  (list 
    "i"
    "xue"
    "xi"
    "note"
    "biji"
    "123"
    ))

; 代码测试区
; (strlst-to-str '("a" "123" "MP"))

(map strlst-to-str
  (permutations
    (random-pick-n candid-strlst 3)))
