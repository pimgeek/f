;; -*- coding:utf-8 -*- ;;
(clear-all)

(define-model 我要为生活增序
  ;; 参数设置
  (sgp :esc t :lf .05 :trace-detail medium) ;; :trace-filter production-firing-only)
  ;; chunk-type 设置
  (chunk-type 情绪状态改善目标 
    当前情绪状态)
  (chunk-type 知识阅读目标
    知识主题名 当前记忆状态)
    
  ;; chunk 设置
  (add-dm ;; 定义相关事实
    (首要目标 isa 情绪状态改善目标
      当前情绪状态 低落)
    (知识阅读 isa 知识阅读目标
      知识主题名 健康的时间观
      当前记忆状态 低))
  ;; production-rule 设置
  (p 增序初始
    =goal>
      isa             情绪状态改善目标
      当前情绪状态    低落
  ==>
    =goal>            
      当前情绪状态    尝试改善中
    +goal>
      isa             知识阅读目标
      知识主题名      =某知识主题名
      当前记忆状态    印象低
    !output!          ("执行说明：开始调整情绪状态……" =某知识主题名)
  )
  (p 知识阅读-健康的时间观
    =goal>
      isa             知识阅读目标
      当前记忆状态    印象低
  ==>
    =goal>
      当前记忆状态    印象中
    !output!          ("执行说明：重新阅读" 健康的时间观)
  )
  (p 知识阅读-社会性拒绝理论
    =goal>
      isa             知识阅读目标
      当前记忆状态    印象低
  ==>
    =goal>
      当前记忆状态    印象中
    !output!          ("执行说明：重新阅读" 健康的时间观)
  )
  ;; 模型启动入口
  (goal-focus 首要目标)
)
