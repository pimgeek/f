;; -*- coding:utf-8 -*- ;;
(clear-all)

(define-model 我要逆袭
  ;; 参数设置
  (sgp :esc t :lf .05 :trace-detail medium) ;; :trace-filter production-firing-only)
  ;; chunk-type 设置
  (chunk-type 社会角色
    收入水平 生存水平 自尊水平)
  (chunk-type 社会角色调整目标 
    当前社会角色 目标社会角色 完成度)
  (chunk-type 身心健康度 
    能量消耗度 认知专注度) ;; 平均值大于 20/24 的时候，就该休息了。
  (chunk-type 身心健康度调整目标
    当前身心健康度 目标身心健康度 完成度)
    
  ;; chunk 设置
  (add-dm ;; 定义相关事实
    ;; 收入水平事实
    (低于平均线 isa chunk) (五倍于平均线 isa chunk)
    ;; 生存水平事实
    (温饱 isa chunk) (小康 isa chunk)
    ;; 自尊水平事实
    (低自尊 isa chunk) (高自尊 isa chunk)
    ;; 目标推进程度事实
    (开始推进 isa chunk) (达成目标 isa chunk)
    ;; 社会角色事实
    (初出茅庐者 isa 社会角色
      收入水平 低于平均线 
      生存水平 温饱
      自尊水平 低自尊)
    (事业有成者 isa 社会角色
      收入水平 五倍于平均线
      生存水平 小康
      自尊水平 高自尊)
    ;; 健康度事实
    (低健康度 isa chunk) (高健康度 isa chunk)
    ;; 定义模型目标
    (首要目标 isa 社会角色调整目标
      当前社会角色 初出茅庐者
      目标社会角色 事业有成者))
  ;; production-rule 设置
  (p 逆袭初始
    =goal>
      isa             社会角色调整目标
      当前社会角色    =社会角色甲
      目标社会角色    =社会角色乙
      完成度          nil
  ==>
    =goal>            
      完成度          开始推进
    +goal>
      isa             身心健康度调整目标
      当前身心健康度  低健康度
      目标身心健康度  高健康度
      完成度          nil
    !output!          ("执行说明：逆袭运动开始了！")
  )
  (p 恢复身心健康
    =goal>
      isa             身心健康度调整目标
      当前身心健康度  =身心健康度一
      目标身心健康度  =身心健康度二
      完成度          nil
  ==>
    =goal>
      完成度          开始推进
    !output!          ("执行说明：开始关注身心健康度……")
  )
  ;; 模型启动入口
  (goal-focus 首要目标)
)
