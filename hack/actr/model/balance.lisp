;; -*- coding:utf-8 -*- ;;
;;(clear-all)

(define-model 身心平衡认知模型
  ;; 参数设置
  (sgp :esc t :lf .05 :trace-detail low) ;; :trace-filter production-firing-only)
  ;; chunk-type 设置
  (chunk-type 身心健康度 
    能量消耗度 认知专注度) ;; 平均值大于 20/24 的时候，就该休息了。
  (chunk-type 身心健康度调整目标
    当前身心健康度 目标身心健康度 完成度)
  
  ;; chunk 设置
  (add-dm ;; 定义相关事实
    ;; 健康度事实
    (低健康度 isa chunk) (高健康度 isa chunk)
    ;; 目标推进程度事实
    (开始推进 isa chunk) (达成目标 isa chunk)
    (首要目标 isa 身心健康度调整目标
      当前身心健康度 低健康度
      目标身心健康度 高健康度))
  ;; production-rule 设置
  (p 恢复身心健康
    =goal>
      isa             身心健康度调整目标
      当前身心健康度  =身心健康度一
      目标身心健康度  =身心健康度二
      完成度          nil
  ==>
    =goal>
      完成度          开始推进
    !output!          ("开始关注身心健康度……")
  )
  ;; 模型启动入口
  ;;(goal-focus 首要目标)
)
