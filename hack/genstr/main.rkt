#!/usr/bin/racket

; 把一个以字符串为元素的列表转化为一个单独的字符串
(define (strlst-to-str strlst)
  (apply string-append strlst))

; 把一个列表中的元素逐一抽取出来，形成全排列 
; 这个函数是 racket 自带的
; (permutation '(a b))

; 从零开始，生成一个自然数的序列
; 这个函数是 racket 自带的
; (range 5)

; 获得一个列表的所有元素的序号，形成一个新的列表
(define (lst-to-idxlst lst)
  (let
    ([len (length lst)])
      (range len)))

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

(permutations candid-strlst)

(lst-to-idxlst candid-strlst)

(list-ref '(a b c) (random 2))

(list-ref candid-strlst 0)


