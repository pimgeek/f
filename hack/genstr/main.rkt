#!/usr/bin/racket

; 把一个以字符串为元素的列表转化为一个单独的字符串

(define (strlst-to-str strlst)
  (apply string-append strlst))


; 函数测试区

(strlst-to-str '("a" "123" "MP"))
