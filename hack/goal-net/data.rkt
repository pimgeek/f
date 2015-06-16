#!/usr/bin/racket

#lang racket

(struct goal (desc step-series))

(define goal-net
  (goal "我要用 racket 中的数据结构记录求解思路\n验收标准：利用 racket 生成的 goal-net 数据结构能够通过测试"
        (list
          (list
            (goal "我要完整地记录尝试达成某目标的所有可观察到的求解动作\n验收标准：每个求解动作都在图中有对应的记录"
                  (list
                    (list
                      (goal "熟悉心流泳道图的关键要素\n验收标准：关键要素均被列出"
                            null)
                      (goal "描述记录求解动作的场景\n验收标准：一两句话说明，让非程序员/非设计师能看明白"
                            null)
                      (goal "描述流程、触发条件、传递物\n验收标准：设计师和程序员能看明白"
                            null)
                      )
                    null))
            (goal "我要完整地写出所有 goal-net 数据项的测试代码\n验收标准：goal-net 的每个数据项至少被测试代码访问一次"
                  (list
                    (list
                      (goal "根据示意图手工创建一系列 goal-net 数据项\n验收标准：示意图上的内容都能保存到 goal-net 数据项中"
                            null)
                      (goal "从 goal-net 的入口目标开始，遍历所有目标描述\n验收标准：示意图上的目标描述都能被列出来"
                            null)
                      )
                    null)))
          null)))

; 定义一个函数，它可以根据输入的整数给出缩进的空格字符串
(define (indent n)
  (make-string (* 2 n) #\space))
(define (indented-list n cont)
  (format "~a* ~a\n" (indent n) cont))

; 定义一个函数，它可以取出给定 goal-net 最外层目标的
; 第一组执行步骤序列的每个 goal-net
; 返回一个列表，列表的每一项元素都是 goal-net
(define (get-subgoals goal-net)
  (if (null? (goal-step-series goal-net))
    null
    (car (goal-step-series goal-net))))

; 打印出给定 goal-net 的最外层目标的文字描述
(display (indented-list 0 (goal-desc goal-net)))

; 打印出 goal-net 最外层目标的第一组执行步骤序列的
; 每个 goal-net 的文字描述
(let
  ([subgoals (get-subgoals goal-net)])
  (for-each 
    (lambda (g)
      (display (indented-list 1 (goal-desc g))))
    subgoals))

