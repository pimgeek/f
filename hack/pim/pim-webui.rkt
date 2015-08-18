#!/usr/bin/mzscheme
; 主要实现 pim 工具的 web 访问界面

#lang racket

; 引入 web-server 相关模块，以便提供 web 服务
(require web-server/servlet
         web-server/servlet-env)

(require (prefix-in txt-proc: "pim-lib.rkt"))

; 设定首页处理函数
(define (main-proc req)
  (response/xexpr
    `(html
       (frameset ; 创建一个网页框架
         ([cols "49%,49%"]) ; 接近平分整个屏幕，宽度上保留一些余量
         (frame
           ([src  "/in"]
            [name "input-frame"]))
         (frame
           ([src "/out"]
            [name "output-frame"]))
         ))))

; 设定输入处理函数
(define (input-proc req)
  (response/xexpr
    `(html
       (body
         (h1 "文字输入区")
         (br)
         (form
           [(method "post")
            (action "/out")
            (target "output-frame")]
           (textarea
             ([name "input-text"])
             "在这里输入文字……")
           (br)
           (textarea
             ([name "para-text"])
             "在这里输入参数……")
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
             [(type "radio")
              (name "proc-type")
              (value "rm-blankline")]
             "移除多余的空行")
           (br)
           (input
             [(type "radio")
              (name "proc-type")
              (value "en-mark")]
             "改为英文标点")
           (br)
           (input
             [(type "radio")
              (name "proc-type")
              (value "filter-word")]
             "利用单词列表做过滤")
           (br)
           (input 
             [(type "submit")
              (value "提交输入内容")])
           )))))

; 设定输出处理函数
(define (output-proc req)
  (response/xexpr
    `(html
       (body
         (h1 "结果显示区")
         (pre
           ,(task-reader req)
           )))))

; 设定任务类型读取函数
(define (task-reader req)
  (let
    ([input-text (form-reader req 'input-text)]
     [para-text  (form-reader req  'para-text)]
     [proc-type  (form-reader req  'proc-type)])
      (cond
        [(equal? proc-type         "echo") (txt-proc:echo     input-text)]
        [(equal? proc-type        "quote") (txt-proc:quot     input-text)]
        [(equal? proc-type "rm-blankline") (text-rm-blankline input-text)]
        [(equal? proc-type      "en-mark") (text-en-mark      input-text)]
        [(equal? proc-type  "filter-word") (text-filter-words input-text para-text)]
        [else                              (format
                                             "表单的请求不明确……~%~a~%"
                                                               proc-type)]
        )))

; 设定表单数据读取函数
(define (form-reader req input-name)
  (if (not (null? req))
    (let
      ([bindings (request-bindings req)])
      (if (exists-binding? input-name bindings)
        (extract-binding/single input-name bindings)
        "请求项为空"
        ))
    "请求为空"))

; 移除多余的空行
(define (text-rm-blankline input-text)
  (regexp-replace* #px"\n{2,}"
    (txt-proc:set-unix-eol input-text) "\n"))

; 设定英文标点
(define (text-en-mark input-text)
  (let*
    ([proc-lv1 (text-en-comma input-text)]
     [proc-lv2 (text-en-full-stop proc-lv1)]
     [proc-lv3 (text-en-single-quote proc-lv2)]
     [proc-lv4 (text-en-double-quote proc-lv3)]
     [proc-lv5 (text-en-round-bracket proc-lv4)]
     [proc-lv6 (text-en-dash proc-lv5)]
     [proc-lv7 (text-remove-url proc-lv6)]
     [proc-lv8 (text-leave-normal-en-words proc-lv7)]
     )
    proc-lv8))

; 设定英文逗号
(define (text-en-comma input-text)
  (regexp-replace* #rx"，" input-text ", "))

; 设定英文句号
(define (text-en-full-stop input-text)
  (regexp-replace* #rx"。" input-text ". "))

; 设定英文单引号
(define (text-en-single-quote input-text)
  (regexp-replace* #rx"(‘|’)" input-text "\'"))

; 设定英文双引号
(define (text-en-double-quote input-text)
  (regexp-replace* #rx"(“|”)" input-text "\""))

; 设定英文圆括号
(define (text-en-round-bracket input-text)
  (let*
    ([left-brackets-fixed (regexp-replace* #rx"(（)" input-text "(")]
     [both-brackets-fixed (regexp-replace* #rx"(）)" left-brackets-fixed ")")])
    both-brackets-fixed))

; 设定英文破折号
(define (text-en-dash input-text)
  (let*
    ([dash1-fixed (regexp-replace* #rx"—" input-text " -- ")]
     [dash2-fixed (regexp-replace* #rx"–" dash1-fixed " - ")])
    dash2-fixed))

; 设定只保留正常的英文单词
(define (text-leave-normal-en-words input-text)
  (let*
    ([proc-lv1 (regexp-replace* #rx"[0-9]+" input-text "")]
     [proc-lv2 (regexp-replace* #rx"^(?![a-zA-Z].*)" proc-lv1 "")]
     [proc-lv3 (regexp-replace* #rx"\\s([a-zA-Z-]*[~@#$%&*/_=+]+)+[a-zA-Z~@#$%&*/_=-]*\\s" proc-lv2 "")]
     [proc-lv4 (regexp-replace* #rx"\\s([~@#$%&*/_=+-]+[a-zA-Z]*)+[a-zA-Z~@#$%&*/_=-]*\\s" proc-lv3 "")]
     [proc-lv5 (regexp-replace* #rx"\\s[a-zA-Z]\\s" proc-lv4 "")])
    proc-lv5))

; 设定移除 URL
(define (text-remove-url input-text)
  (regexp-replace* #rx"https?://[^ \n]+" input-text ""))

; 设定移除多余前导和末尾空格的函数
(define (multi-line-trim input-text)
  (let*
    [(unix-eol-text (txt-proc:set-unix-eol input-text))
     (split-input-list (string-split unix-eol-text "\n"))
     (trimmed-input (map string-trim split-input-list))
     (joined-input (string-join trimmed-input "\n"))]
    joined-input))

; 设定过滤包含某英文单词的行
(define (text-filter-words input-text para-text)
  (let*
    [(split-para (string-split (txt-proc:set-unix-eol para-text) "\n"))
     (trimmed-para-list (map string-trim split-para))
     (joined-para (string-join trimmed-para-list "|"))
     (pregex-str (pregexp (string-append "(" joined-para ")")))
     (trimmed-input (multi-line-trim input-text)) 
     (replaced-input (regexp-replace* pregex-str trimmed-input ""))]
    (text-rm-blankline replaced-input)
    ))

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
      [(regexp-match "^/$" uri-str)      (main-proc req)] 
      [(regexp-match "^/in$" uri-str)   (input-proc req)] 
      [(regexp-match "^/out$" uri-str) (output-proc req)] 
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
