#!/usr/bin/mzscheme
; 主要实现 pim 工具的常用支持函数

#lang racket

; 设定字符串原样回显函数
(define (echo input-text)
  input-text)

; 设定字符串加双引号函数
(define (quot input-text)
  (string-append "\"" input-text "\""))

; 设定把换行符统一替换为UNIX格式的函数
(define (set-unix-eol input-text)
  (regexp-replace* #px"(\r\n|\n\r)" input-text "\n"))

(provide (all-defined-out))