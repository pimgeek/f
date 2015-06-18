#!/usr/bin/racket
; gosol.rkt : 一个用于记录目标求解过程的数据结构及其相关操作集合
;             gosol = gosol + Solution 希望这样比较好记
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

(struct gosolchain (idea-hint gosol-list))

; 定义 hint 数据结构
; 其中
; desc     : 与 hint 相关的概要文字说明   ；string 类型
; uri      : 与 hint 相关的统一访问地址   ；string 类型
; img-list : 与 hint 相关的一系列图片地址 ；list   类型

(struct hint (desc uri img-list))

; #### 定义 gosol 的数据操作 ####

; 创建一个空的 gosol 数据结构

(define (gosol-init)
  (gosol null null null null))

; 判断一个 gosol 结构是否为空

(define (gosol-null? a-gosol)
  (if (and (null? (gosol-goal-hint a-gosol))
           (null? (gosol-check-list a-gosol))
           (null? (gosol-gosolchain-list a-gosol))
           (null? (gosol-gtd-hint a-gosol)))
    #t
    #f))

; 打印当前 gosol 的所有描述文字

(define (gosol-dump-goals a-gosol)
  (cond
    [(gosol-null? a-gosol) (list #f)]
    [(null? (gosol-gosolchain-list a-gosol))
     (list
       (hint-desc (gosol-goal-hint a-gosol)))]
    [else
      (list
        (hint-desc (gosol-goal-hint a-gosol))
        (map
          (lambda (gosols)
            (map gosol-dump-goals gosols))
          (gosol-gosolchain-list a-gosol)))]
    ))

; 为一个空白的 gosol 添加顶层 goal

(define (gosol-insert-top-goal a-gosol goal-desc goal-check-list)
  (cond
    [(not (gosol-null? a-gosol)) #f]
    [else
      (let
        [(a-goal-hint (hint goal-desc "" '()))]
        (set-gosol-goal-hint! a-gosol a-goal-hint)
        (set-gosol-check-list! a-gosol goal-check-list))
      #t]))

; #### 尝试调用 gosol 的各项操作
; 定义初始 gosol

(define new-gosol (gosol-init))

(displayln new-gosol)

(gosol-insert-top-goal new-gosol
                       "写出 gosol 的基础操作集合"
                       (list "1 每种操作都要有具体而确定的名称"
                             "2 每种操作具体做什么要写清楚"
                             "3 可以在 workflowy 工具中模拟每种操作"))

(displayln new-gosol)
