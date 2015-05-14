#!/usr/bin/racket

#lang racket

;;; 这里是注释文字

;; 单行注释以分号 ; 开始

#| 这里是
多行的
注释文字
  #| 还可嵌套哦
  |#
|#

;; 下面这种写法，可以一次注释掉一整个 s-exp
#; (displayln
     "hello world!")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 1. 原始数据类型与操作符
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; 数字

999999999999 ; 整数类型

#b11         ; 二进制数

#o76         ; 八进制数

#xFF         ; 十六进制数

3.14         ; 实数

6.02e+23     ; 科学计数法

1/2          ; 有理数

1+2i         ; 复数，加号左右别加空格，不然会出错

;; 函数的写法是这样的 (func arg1 arg2 ...)
;; 其中 func 是函数名， argN 是函数的参数

;; 如果你只想表示一个列表而不想表示函数调用
;; 就这样写 '(elem1 elem2 elem3 ...)
;; 这样 elem1 就不会被理解为函数名
'(+ 1 2)              ; => '(1 + 2)

;; 来点算术运算
(+ 1 1)               ; => 2

(- 8 1)               ; => 7

(* 10 2)              ; => 20

(expt 2 3)            ; => 8

(quotient 5 2)        ; => 2

(remainder 5 2)       ; => 1

(/ 35 5)              ; => 7

(/ 1 3)               ; => 1/3

(exact->inexact 1/3)  ; => 1/3

(+ 1+2i 2-3i)         ; => 3-i

;;; 布尔类型

#t                                    ; => 真值

#f                                    ; => 假值 -- 任何不是 #f 的值均为真

(not #t)                              ; => 假值

(and 0 #f (error "无法执行到此处"))   ; => 假值

(or  #f 0 (error "无法执行到此处"))   ; => 0

;;; 字符类型

#\A        ; => #\A

#\λ        ; => #\λ 

#\u03BB    ; => #\λ

;;; 字符串是固定长度的字符序列

"Hello, world!"

"Benjamin \"Bugsy\" Siegel"   ; 反斜杠是转义字符

"Foo\tbar\41\x21\u0021\a\r\n" ; 也可以使用类 C 语言的转义序列，包括 Unicode 序列

"λx:(μα.α→α).xx"              ; 可以包含 Unicode 字符 

;; 字符串之间可以相加
(string-append "Hello " "world!") ; => "Hello world!"

;; 字符串可以被当做一个字符的列表来处理
(string-ref "Apple" 0) ; => #\A

;; 利用 format 函数可以进行格式化打印
(format "~a can be ~a" "strings" "formatted")

;; 直接利用 printf 打印，非常简单
(printf "I'm Racket. Nice to meet you!\n")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 2. 变量
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 可以用 define 创建变量
;; 变量名可以是除去 ()[]{}",'`;#|\ 以外的任意字符
(define some-var 5)
some-var ; => 5

;; 变量名可以使用 Unicode 字符
(define ⊆ subset?)
(⊆ (set 3 2) (set 1 2 3)) ; => #t

;; 试图访问未赋值的变量，会导致异常
x ; => x: undefined ...

;; 局部绑定：'me' 只在 (let ...) 这个 s-exp 之内被绑定到 "Bob"
(let ([me "Bob"])
  "Alice"
  me) ; => "Bob"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 3. 结构与集合
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 结构 struct
(struct dog (name breed age))

(define my-pet
  (dog "lassie" "collie" 5))

my-pet ; => #<dog> 类型的结构

(dog? my-pet) ; => #t

(dog-name my-pet) ; => "lassie"

;;; 二元组 pair (不可修改)
;; 利用 `cons' 可以构造 pair, 
;; 用 car 可以抽取 pair 的第一个元素
;; 用 cdr 可以抽取 pair 的第二个元素
(cons 1 2) ; => '(1 . 2)

(car (cons 1 2)) ; => 1

(cdr (cons 1 2)) ; => 2

;;; 列表 list

;; list 是链接列表型数据结构，由以 cons 构造出的 pair 构成，
;; 并且始终以 null 或者 '() 作为 list 的结尾标记
(cons 1 (cons 2 (cons 3 null))) ; => '(1 2 3)

;; 使用 list 可以便捷地构造列表数据结构
;; 它是一个参数列表长度不固定的函数
(list 1 2 3) ; => '(1 2 3)

;; 利用 quote 可以构造列表常量
'(1 2 3) ; => '(1 2 3)

;; 可以使用 cons 为列表的头部添加元素
(cons 4 '(1 2 3)) ; => '(4 1 2 3)

;; 可以使用 append 把两个列表合并到一起
(append '(1 2) '(3 4)) ; => '(1 2 3 4)

;; 列表是非常基础的数据类型，所以有大量的函数可以处理它们
;; 下面给出几个例子：
(map add1 '(1 2 3))          ; => '(2 3 4)

(map + '(1 2 3) '(10 20 30)) ; => '(11 22 33)

(filter even? '(1 2 3 4))    ; => '(2 4)

(count even? '(1 2 3 4))     ; => 2

(take '(1 2 3 4) 2)          ; => '(1 2)

(drop '(1 2 3 4) 2)          ; => '(3 4)

;;; 向量 vector

;; 向量是固定长度的序列
#(1 2 3) ; => '#(1 2 3)

;; 使用 vector-append 把多个向量合并到一起
(vector-append #(1 2 3) #(4 5 6)) ; => #(1 2 3 4 5 6)

;;; 集合 set

;; 从列表创建一个集合
(list->set '(1 2 3 1 2 3 3 2 1 3 2 1)) ; => (set 1 2 3)

;; 使用 set-add 为集合添加成员
;; 函数式特性：返回一个新的集合，而不是修改作为输入的集合
(set-add (set 1 2 3) 4) ; => (set 1 2 3 4)

;; 利用 set-remove 从集合中移除成员
(set-remove (set 1 2 3) 1) ; => (set 2 3)

;; 利用 set-member? 测试某个元素是否包含于特定集合
(set-member? (set 1 2 3) 1) ; => #t

(set-member? (set 1 2 3) 4) ; => #f

;;; 哈希

;; 创建一个不可修改的哈希表(下方有可修改的列子)
(define m (hash 'a 1 'b 2 'c 3))

;; 从哈希表中取回一个值
(hash-ref m 'a) ; => 1

;; 尝试获取尚不存在的值，会造成异常
(hash-ref m 'd) => no value found

;; 对于哈希 key 没有对应 value 的情况，可以给出一个默认值
(hash-ref m 'd 0) ; => 0

;; 使用 hash-set 扩展一个不可修改的哈希表
;; 返回的是一个新的得到扩展的哈希表，而不会修改原来的哈希表
(define m2 (hash-set m 'd 4))
m2 ; => '#hash((b . 2) (a . 1) (d . 4) (c . 3))

;; 一定要记住，这些哈希表是不可修改的！
m ; => '#hash((b . 2) (a . 1) (c . 3))  <-- no `d'

;; 使用 hash-remove 移除哈希表中的一部分 key (同样是函数式的)
(hash-remove m 'a) ; => '#hash((b . 2) (c . 3))

m ; => '#hash((b . 2) (a . 1) (c . 3))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 3. 函数
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 使用 lambda 创建函数
;; 函数总是返回它内部最后一个表达式的值
(lambda () "Hello World") ; => #<procedure>

;; 也可以使用 Unicode 字符 λ 代替 lambda
(λ () "Hello World")     ; => 与上面定义效果一样

;; 使用括号来调用所有函数，也包括 lambda 表达式
((lambda () "Hello World")) ; => "Hello World"

((λ () "Hello World"))      ; => "Hello World"

;; 把函数赋值给一个变量
(define hello-world (lambda () "Hello World"))

(hello-world) ; => "Hello World"

;; 你也可以使用下面这个用于定义函数的语法糖缩短代码：
(define (hello-world2) "Hello World")

;; lambda 后面的 () 中是这个函数的参数列表
(define hello
  (lambda (name)
    (string-append "Hello " name)))

(hello "Steve") ; => "Hello Steve"

;; 或者，等价的语法糖式定义如下：
(define (hello2 name)
  (string-append "Hello " name))

;; 你还可以定义参数列表长度不固定的函数
;; 只要利用 case-lambda
(define hello3
  (case-lambda
    [() "Hello World"]
    [(name) (string-append "Hello " name)]))

(hello3 "Jake") ; => "Hello Jake"

(hello3) ; => "Hello World"

;; 或者也可以制定可选参数，并且为可选参数指定默认值
(define (hello4 [name "World"])
  (string-append "Hello " name))

(hello4 "Jake") ; => "Hello Jake"

(hello4) ; => "Hello World"

;; 还可以把函数的参数都打包放进一个列表中
(define (count-args . args)
  (format "You passed ~a args: ~a" (length args) args))

(count-args 1 2 3) ; => "You passed 3 args: (1 2 3)"

;; 或者利用不带语法糖的 lambda 形式
(define count-args2
  (lambda args
    (format "You passed ~a args: ~a" (length args) args)))

;; 你可以同时使用常规参数和打包的参数
(define (hello-count name . args)
  (format "Hello ~a, you passed ~a extra args" name (length args)))

(hello-count "Finn" 1 2 3)
; => "Hello Finn, you passed 3 extra args"

;; 不带语法糖：
(define hello-count2
  (lambda (name . args)
    (format "Hello ~a, you passed ~a extra args" name (length args))))

;; 还可以带上关键词 keyword 
;; 使用 keyword 以后，就不必严格按定义顺序，一个不落地使用所有参数)
(define (hello-k #:name [name "World"] #:greeting [g "Hello"] . args)
  (format "~a ~a, ~a extra args" g name (length args)))

(hello-k)                 ; => "Hello World, 0 extra args"

(hello-k 1 2 3)           ; => "Hello World, 3 extra args"

(hello-k #:greeting "Hi") ; => "Hi World, 0 extra args"

(hello-k #:name "Finn" #:greeting "Hey") ; => "Hey Finn, 0 extra args"

(hello-k 1 2 3 #:greeting "Hi" #:name "Finn" 4 5 6)
                                         ; => "Hi Finn, 6 extra args"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 4. 相等关系
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; for numbers use `='
(= 3 3.0) ; => #t
(= 2 1)   ; => #f

;; `eq?' returns #t if 2 arguments refer to the same object (in memory), 
;; #f otherwise.
;; In other words, it's a simple pointer comparison.
(eq? '() '()) ; => #t, since there exists only one empty list in memory
(let ([x '()] [y '()])
  (eq? x y))  ; => #t, same as above

(eq? (list 3) (list 3)) ; => #f
(let ([x (list 3)] [y (list 3)])
  (eq? x y))            ; => #f — not the same list in memory!

(let* ([x (list 3)] [y x])
  (eq? x y)) ; => #t, since x and y now point to the same stuff

(eq? 'yes 'yes) ; => #t
(eq? 'yes 'no)  ; => #f

(eq? 3 3)   ; => #t — be careful here
            ; It’s better to use `=' for number comparisons.
(eq? 3 3.0) ; => #f

(eq? (expt 2 100) (expt 2 100))               ; => #f
(eq? (integer->char 955) (integer->char 955)) ; => #f

(eq? (string-append "foo" "bar") (string-append "foo" "bar")) ; => #f

;; `eqv?' supports the comparison of number and character datatypes.
;; for other datatypes, `eqv?' and `eq?' return the same result.
(eqv? 3 3.0)                                   ; => #f
(eqv? (expt 2 100) (expt 2 100))               ; => #t
(eqv? (integer->char 955) (integer->char 955)) ; => #t

(eqv? (string-append "foo" "bar") (string-append "foo" "bar"))   ; => #f

;; `equal?' supports the comparison of the following datatypes:
;; strings, byte strings, pairs, mutable pairs, vectors, boxes, 
;; hash tables, and inspectable structures.
;; for other datatypes, `equal?' and `eqv?' return the same result.
(equal? 3 3.0)                                                   ; => #f
(equal? (string-append "foo" "bar") (string-append "foo" "bar")) ; => #t
(equal? (list 3) (list 3))                                       ; => #t

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 5. Control Flow
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Conditionals

(if #t               ; test expression
    "this is true"   ; then expression
    "this is false") ; else expression
; => "this is true"

;; In conditionals, all non-#f values are treated as true
(member 'Groucho '(Harpo Groucho Zeppo)) ; => '(Groucho Zeppo)
(if (member 'Groucho '(Harpo Groucho Zeppo))
    'yep
    'nope)
; => 'yep

;; `cond' chains a series of tests to select a result
(cond [(> 2 2) (error "wrong!")]
      [(< 2 2) (error "wrong again!")]
      [else 'ok]) ; => 'ok

;;; Pattern Matching

(define (fizzbuzz? n)
  (match (list (remainder n 3) (remainder n 5))
    [(list 0 0) 'fizzbuzz]
    [(list 0 _) 'fizz]
    [(list _ 0) 'buzz]
    [_          #f]))

(fizzbuzz? 15) ; => 'fizzbuzz
(fizzbuzz? 37) ; => #f

;;; Loops

;; Looping can be done through (tail-) recursion
(define (loop i)
  (when (< i 10)
    (printf "i=~a\n" i)
    (loop (add1 i))))
(loop 5) ; => i=5, i=6, ...

;; Similarly, with a named let
(let loop ((i 0))
  (when (< i 10)
    (printf "i=~a\n" i)
    (loop (add1 i)))) ; => i=0, i=1, ...

;; See below how to add a new `loop' form, but Racket already has a very
;; flexible `for' form for loops:
(for ([i 10])
  (printf "i=~a\n" i)) ; => i=0, i=1, ...
(for ([i (in-range 5 10)])
  (printf "i=~a\n" i)) ; => i=5, i=6, ...

;;; Iteration Over Other Sequences
;; `for' allows iteration over many other kinds of sequences:
;; lists, vectors, strings, sets, hash tables, etc...

(for ([i (in-list '(l i s t))])
  (displayln i))

(for ([i (in-vector #(v e c t o r))])
  (displayln i))

(for ([i (in-string "string")])
  (displayln i))

(for ([i (in-set (set 'x 'y 'z))])
  (displayln i))

(for ([(k v) (in-hash (hash 'a 1 'b 2 'c 3 ))])
  (printf "key:~a value:~a\n" k v))

;;; More Complex Iterations

;; Parallel scan of multiple sequences (stops on shortest)
(for ([i 10] [j '(x y z)]) (printf "~a:~a\n" i j))
; => 0:x 1:y 2:z

;; Nested loops
(for* ([i 2] [j '(x y z)]) (printf "~a:~a\n" i j))
; => 0:x, 0:y, 0:z, 1:x, 1:y, 1:z

;; Conditions
(for ([i 1000]
      #:when (> i 5)
      #:unless (odd? i)
      #:break (> i 10))
  (printf "i=~a\n" i))
; => i=6, i=8, i=10

;;; Comprehensions
;; Very similar to `for' loops -- just collect the results

(for/list ([i '(1 2 3)])
  (add1 i)) ; => '(2 3 4)

(for/list ([i '(1 2 3)] #:when (even? i))
  i) ; => '(2)

(for/list ([i 10] [j '(x y z)])
  (list i j)) ; => '((0 x) (1 y) (2 z))

(for/list ([i 1000] #:when (> i 5) #:unless (odd? i) #:break (> i 10))
  i) ; => '(6 8 10)

(for/hash ([i '(1 2 3)])
  (values i (number->string i)))
; => '#hash((1 . "1") (2 . "2") (3 . "3"))

;; There are many kinds of other built-in ways to collect loop values:
(for/sum ([i 10]) (* i i)) ; => 285
(for/product ([i (in-range 1 11)]) (* i i)) ; => 13168189440000
(for/and ([i 10] [j (in-range 10 20)]) (< i j)) ; => #t
(for/or ([i 10] [j (in-range 0 20 2)]) (= i j)) ; => #t
;; And to use any arbitrary combination, use `for/fold'
(for/fold ([sum 0]) ([i '(1 2 3 4)]) (+ sum i)) ; => 10
;; (This can often replace common imperative loops)

;;; Exceptions

;; To catch exceptions, use the `with-handlers' form
(with-handlers ([exn:fail? (lambda (exn) 999)])
  (+ 1 "2")) ; => 999
(with-handlers ([exn:break? (lambda (exn) "no time")])
  (sleep 3)
  "phew") ; => "phew", but if you break it => "no time"

;; Use `raise' to throw exceptions or any other value
(with-handlers ([number?    ; catch numeric values raised
                 identity]) ; return them as plain values
  (+ 1 (raise 2))) ; => 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6. Mutation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Use `set!' to assign a new value to an existing variable
(define n 5)
(set! n (add1 n))
n ; => 6

;; Use boxes for explicitly mutable values (similar to pointers or
;; references in other languages)
(define n* (box 5))
(set-box! n* (add1 (unbox n*)))
(unbox n*) ; => 6

;; Many Racket datatypes are immutable (pairs, lists, etc), some come in
;; both mutable and immutable flavors (strings, vectors, hash tables,
;; etc...)

;; Use `vector' or `make-vector' to create mutable vectors
(define vec (vector 2 2 3 4))
(define wall (make-vector 100 'bottle-of-beer))
;; Use vector-set! to update a slot
(vector-set! vec 0 1)
(vector-set! wall 99 'down)
vec ; => #(1 2 3 4)

;; Create an empty mutable hash table and manipulate it
(define m3 (make-hash))
(hash-set! m3 'a 1)
(hash-set! m3 'b 2)
(hash-set! m3 'c 3)
(hash-ref m3 'a)   ; => 1
(hash-ref m3 'd 0) ; => 0
(hash-remove! m3 'a)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 7. Modules
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Modules let you organize code into multiple files and reusable
;; libraries; here we use sub-modules, nested in the whole module that
;; this text makes (starting from the "#lang" line)

(module cake racket/base ; define a `cake' module based on racket/base

  (provide print-cake) ; function exported by the module

  (define (print-cake n)
    (show "   ~a   " n #\.)
    (show " .-~a-. " n #\|)
    (show " | ~a | " n #\space)
    (show "---~a---" n #\-))

  (define (show fmt n ch) ; internal function
    (printf fmt (make-string n ch))
    (newline)))

;; Use `require' to get all `provide'd names from a module
(require 'cake) ; the ' is for a local submodule
(print-cake 3)
; (show "~a" 1 #\A) ; => error, `show' was not exported

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 8. Classes and Objects
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Create a class fish% (-% is idiomatic for class bindings)
(define fish%
  (class object%
    (init size) ; initialization argument
    (super-new) ; superclass initialization
    ;; Field
    (define current-size size)
    ;; Public methods
    (define/public (get-size)
      current-size)
    (define/public (grow amt)
      (set! current-size (+ amt current-size)))
    (define/public (eat other-fish)
      (grow (send other-fish get-size)))))

;; Create an instance of fish%
(define charlie
  (new fish% [size 10]))

;; Use `send' to call an object's methods
(send charlie get-size) ; => 10
(send charlie grow 6)
(send charlie get-size) ; => 16

;; `fish%' is a plain "first class" value, which can get us mixins
(define (add-color c%)
  (class c%
    (init color)
    (super-new)
    (define my-color color)
    (define/public (get-color) my-color)))
(define colored-fish% (add-color fish%))
(define charlie2 (new colored-fish% [size 10] [color 'red]))
(send charlie2 get-color)
;; or, with no names:
(send (new (add-color fish%) [size 10] [color 'red]) get-color)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 9. Macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Macros let you extend the syntax of the language

;; Let's add a while loop
(define-syntax-rule (while condition body ...)
  (let loop ()
    (when condition
      body ...
      (loop))))

(let ([i 0])
  (while (< i  10)
    (displayln i)
    (set! i (add1 i))))

;; Macros are hygienic, you cannot clobber existing variables!
(define-syntax-rule (swap! x y) ; -! is idiomatic for mutation
  (let ([tmp x])
    (set! x y)
    (set! y tmp)))

(define tmp 2)
(define other 3)
(swap! tmp other)
(printf "tmp = ~a; other = ~a\n" tmp other)
;; The variable `tmp` is renamed to `tmp_1`
;; in order to avoid name conflict
;; (let ([tmp_1 tmp])
;;   (set! tmp other)
;;   (set! other tmp_1))

;; But they are still code transformations, for example:
(define-syntax-rule (bad-while condition body ...)
  (when condition
    body ...
    (bad-while condition body ...)))
;; this macro is broken: it generates infinite code, if you try to use
;; it, the compiler will get in an infinite loop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 10. Contracts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Contracts impose constraints on values exported from modules

(module bank-account racket
  (provide (contract-out
            [deposit (-> positive? any)] ; amounts are always positive
            [balance (-> positive?)]))

  (define amount 0)
  (define (deposit a) (set! amount (+ amount a)))
  (define (balance) amount)
  )

(require 'bank-account)
(deposit 5)

(balance) ; => 5

;; Clients that attempt to deposit a non-positive amount are blamed
;; (deposit -5) ; => deposit: contract violation
;; expected: positive?
;; given: -5
;; more details....

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 11. Input & output
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Racket has this concept of "port", which is very similar to file
;; descriptors in other languages

;; Open "/tmp/tmp.txt" and write "Hello World"
;; This would trigger an error if the file's already existed
(define out-port (open-output-file "/tmp/tmp.txt"))
(displayln "Hello World" out-port)
(close-output-port out-port)

;; Append to "/tmp/tmp.txt"
(define out-port (open-output-file "/tmp/tmp.txt"
                                   #:exists 'append))
(displayln "Hola mundo" out-port)
(close-output-port out-port)

;; Read from the file again
(define in-port (open-input-file "/tmp/tmp.txt"))
(displayln (read-line in-port))
; => "Hello World"
(displayln (read-line in-port))
; => "Hola mundo"
(close-input-port in-port)

;; Alternatively, with call-with-output-file you don't need to explicitly
;; close the file
(call-with-output-file "/tmp/tmp.txt"
  #:exists 'update ; Rewrite the content
  (λ (out-port)
    (displayln "World Hello!" out-port)))

;; And call-with-input-file does the same thing for input
(call-with-input-file "/tmp/tmp.txt"
  (λ (in-port)
    (displayln (read-line in-port))))
