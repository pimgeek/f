#!/usr/bin/racket

#lang racket

(struct goal (desc steps))

(define goal-net
  (goal "我要完整地记录尝试达成某目标的所有可观察到的求解动作\n验收标准：每个求解动作都在图中有对应的记录"
        (list
          (goal "熟悉心流泳道图的关键要素\n验收标准：关键要素均被列出"
                null)
          (goal "描述记录求解动作的场景\n验收标准：一两句话说明，让非程序员/非设计师能看明白"
                null)
          (goal "描述流程、触发条件、传递物\n验收标准：设计师和程序员能看明白"
                null)
              )))

(goal-desc goal-net)

(goal-steps goal-net)

(map goal-desc (goal-steps goal-net))

