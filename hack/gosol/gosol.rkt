#!/usr/bin/racket
; gosol.rkt : 一个用于记录目标求解过程的数据结构及其相关操作集合
;             gosol = Goal + Solution 希望这样比较好记
; author    : pimgeek
; date      : 2015.06.17

#lang racket

; #### 定义 gosol 数据结构 ####

; 定义 gosol 数据结构
; gosol 是一个无头无尾的循环结构，其大概循环模式如下
; ... ... 
;   gosol
;     gosolchain-list
;       gosolchain
;         gosol
;           ... ...
;       gosolchain
;         gosol
;           ... ...
;       ... ...
; 其中
; goal-hint       : 与顶层 goal 相关的超链接或多媒体信息     ；hint 类型
; check-list      : 与顶层 goal 相关的验收标准条目列表       ；list 类型
; gosolchain-list : 映射顶层 goal 求解过程的 gosolchain 列表 ；list 类型
; gtd-hint        : 针对顶层 goal 的现成的 gtd 方法信息      ；hint 类型

(struct gosol (goal-hint check-list gosolchain-list gtd-hint) #:mutable)

; 定义 gosolchain 数据结构
; 其中
; idea-hint  : 与求解思路相关的超链接或多媒体信息 ：hint 类型
; gosol-list : 依照求解思路形成的目标列表         ；list 类型

(struct gosolchain (idea-hint gosol-list) #:mutable)

; 定义 hint 数据结构
; 其中
; desc     : 与 hint 相关的概要文字说明   ；string 类型
; uri      : 与 hint 相关的统一访问地址   ；string 类型
; img-list : 与 hint 相关的一系列图片地址 ；list   类型

(struct hint (desc uri img-list) #:mutable)

; #### 定义 gosol 的数据操作 ####

; 创建一个空的 hint 数据结构

(define (hint-init)
  (hint "" "" null))

; 定义一个判断 hint 实例是否为空的方法

(define (hint-null? a-hint)
  (if (and (equal? (hint-desc a-hint) "")
           (equal? (hint-uri a-hint) "")
           (null? (hint-img-list a-hint)))
    #t
    #f))

; 创建一个空的 gosol 数据结构

(define (gosol-init)
  (gosol (hint-init)
         null
         null
         (hint-init)))

; 定义一个判断 gosol 是否为空的方法

(define (gosol-null? a-gosol)
  (if (and (hint-null? (gosol-goal-hint a-gosol))
           (null? (gosol-check-list a-gosol))
           (null? (gosol-gosolchain-list a-gosol))
           (hint-null? (gosol-gtd-hint a-gosol)))
    #t
    #f))

; 抽取当前 gosol 的所有描述文字，以 s-exp 格式输出

(define (gosol-dump-goals a-gosol)
  (cond
    [(gosol-null? a-gosol) (list null)]
    [(null? (gosol-gosolchain-list a-gosol))
     (list
       (hint-desc (gosol-goal-hint a-gosol)))]
    [else
      (list
        (hint-desc (gosol-goal-hint a-gosol))
        (map
          (lambda (gosolchain)
            (map
              gosol-dump-goals
              (gosolchain-gosol-list gosolchain)))
          (gosol-gosolchain-list a-gosol)))]
    ))

; 抽取当前 gosol 的所有描述文字，以 yaml 格式输出

(define (gosol-dump-goals-yaml a-gosol indent-level)
  (cond
    [(gosol-null? a-gosol)
     (format "~a- gosol: ''\n"
             (make-string (* 2 indent-level) #\space))]
    [(null? (gosol-gosolchain-list a-gosol))
     (format "~a- gosol: '~a'\n"
             (make-string (* 2 indent-level) #\space)
             (hint-desc (gosol-goal-hint a-gosol)))]
    [else
      (format "~a- gosol: '~a'\n~agosol-chains:\n~a- gosol-chain:\n~a"
              (make-string (* 2 indent-level) #\space)
              (hint-desc (gosol-goal-hint a-gosol))
              (make-string (* 2 (+ 1 indent-level)) #\space)
              (make-string (* 2 (+ 2 indent-level)) #\space)
              (apply
                string-append
                (map
                  (lambda (gosolchain)
                    (apply
                      string-append
                      (map
                        (lambda (gosol)
                          (gosol-dump-goals-yaml gosol (+ 3 indent-level)))
                        (gosolchain-gosol-list gosolchain))))
                  (gosol-gosolchain-list a-gosol))))]
    ))

; 为一个 gosol 添加目标描述

(define (gosol-set-goal-desc a-gosol goal-desc)
  (cond
    [(null? (goal-hint a-gosol)) #f]
    [else
      (let
        [(a-goal-hint (hint goal-desc "" '()))]
        (set-gosol-goal-hint! a-gosol a-goal-hint))
      #t]))

; 为一个尚未定义目标验收标准的 gosol 添加目标验收标准

(define (gosol-set-goal-desc a-gosol goal-check-list)
  (cond
    [(not (gosol-null? a-gosol)) #f]
    [else
      (let
        [(a-goal-hint (hint goal-desc "" '()))]
        (set-gosol-goal-hint! a-gosol a-goal-hint))
      #t]))

; 为一个已经设定了目标描述的 gosol 添加一个 subgoal

(define (gosol-insert-subgoal a-gosol a-subgosol)
  (cond
    [(gosol-null? a-gosol) #f]
    [else
      (let
        [(a-gosolchain (gosolchain '() (list a-subgosol)))]
        (set-gosol-gosolchain-list! a-gosol (list a-gosolchain))
        )
      #t]))

; #### 尝试调用 gosol 的各项操作

; 定义初始 gosol

(define new-gosol (gosol-init))

(displayln
  (gosol-dump-goals-yaml new-gosol 0))

(gosol-insert-topgoal new-gosol
                       "写出 gosol 的基础操作集合"
                       (list "1 每种操作都要有具体而确定的名称"
                             "2 每种操作具体做什么要写清楚"
                             "3 可以在 workflowy 工具中模拟每种操作"))

(displayln
  (gosol-dump-goals-yaml new-gosol 0))

(define new-subgosol (gosol-init))
(gosol-set-goal-)
gosol-insert-subgoal new-gosol
                       "创建初始 gosol 结构"
                       (list "1 命名为 gosol-init"
                             "2 创建一个各字段皆为 null 的结构"
                             "3 在 workflowy 中只要注册并登录即可模拟此操作")

(displayln (gosol-dump-goals-yaml new-gosol 0))

(gosol-dump-goals new-gosol)
