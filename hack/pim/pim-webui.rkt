#!/usr/bin/racket
; 主要实现 web 访问界面

#lang racket

; 引入 web-server 相关模块
(require web-server/servlet
         web-server/servlet-env)

; 设定正常访问首页时返回的内容
(define (main-page req)
  (response/xexpr
    `(html
       (body
         (h1 "文字输入区域")
         (br)
         (form
           [(method "post")
            (action "/result")]
           (textarea
             ([name "input-text"])
             "在这里输入文字……")
           (br)
           (input
             [(type "radio")
              (name "proc-type")
              (value "echo")]
             "原样照搬")
           (br)
           (input
             [(type "radio")
              (name "proc-type")
              (value "quote")]
             "打个引号")
           (br)
           (input 
             [(type "submit")
              (value "提交输入内容")])
           )))))

; 设定
(define (result-page req)
  (response/xexpr
    `(html
       (body
         (h1 "结果显示区域")
         (br)
         (div
           ,(task-runner req)
           )))))

; 设定
(define (form-reader req input-name)
  (if (not (null? req))
    (let
      ([bindings (request-bindings req)])
      (if (exists-binding? input-name bindings)
        (extract-binding/single input-name bindings)
        "读取失败"
        ))
    "读取失败"))

; 设定
(define (task-runner req)
  (let
    ([input-text (form-reader req 'input-text)]
     [proc-type  (form-reader req  'proc-type)])
      (cond
        [(equal? proc-type  "echo") (text-echo  input-text)]
        [(equal? proc-type "quote") (text-quote input-text)]
        [else                       (format
                                      "未选择处理方式……~%~a~%"
                                                 proc-type)]
        )))

; 设定
(define (text-echo input-text)
  input-text)

; 设定
(define (text-quote input-text)
  (string-append "\"" input-text "\""))

; 设定非正常访问时返回的错误信息
(define (error-page)
  (response/xexpr
    `(html
       (body
         (h1 "Error!")
         ))))

; 设定 servlet 请求处理入口函数
(define (pim-app req)
  (let*
    ([url (request-uri req)]
     [uri-str (url->string url)])
    (cond
      [(regexp-match "^/$" uri-str) (main-page req)] 
      [(regexp-match "^/result$" uri-str) (result-page req)] 
      [else (error-page)]
      )))

; 启动 web-server 并开始服务

(serve/servlet
  pim-app             ; 使用 pim-app 作为响应 servlet 请求的入口

  #:port          80  ; 规定 web-server 使用 80 端口

  #:servlet-path  "/" ; 规定 web-server 启动时默认打开的首页

  ; 规定 servlet 负责处理路径中出现数字，字母或'/'的请求
  ; 一旦路径出现'.'就不再由 servlet 处理了。
  #:servlet-regexp #rx"^/[a-zA-Z0-9/-?=]*$"

  #:listen-ip     #f  ; 开放局域网访问 ip

  #:command-line? #t  ; 禁止自动打开浏览器

  #:quit?         #t  ; 允许从浏览器端关停 web-server

  )
