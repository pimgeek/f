;; -*- coding:utf-8 -*- ;;
(clear-all)

(define-model 两位数加法运算认知模型
  ; 参数设置
  (sgp :esc t :lf .05 :trace-detail high) ;; :trace-filter production-firing-only)

  ;; Add Chunk-types here
  (chunk-type 加法运算事实 被加数 加数 和数)
  (chunk-type 两位数加法运算 被加数十位 被加数个位 加数十位 加数个位 和数十位 和数个位 当前进位)
  
  ;; Add Chunks here
  (add-dm
    (3+4 isa 加法运算事实 被加数 3 加数 4 和数 7)
    (6+7 isa 加法运算事实 被加数 6 加数 7 和数 13)
    (10+3 isa 加法运算事实 被加数 10 加数 3 和数 13)
    (1+7 isa 加法运算事实 被加数 1 加数 7 和数 8)
    (36+47 isa 两位数加法运算 被加数十位 3 被加数个位 6 加数十位 4 加数个位 7)
  )
  
  ;; Add productions here
  (p 加法运算初始
    =goal>
      isa         两位数加法运算
      被加数十位  =某数甲
      被加数个位  =某数乙
      加数十位    =某数丙
      加数个位    =某数丁
      和数十位    nil
      和数个位    nil
  ==>
    =goal>
      和数十位    待定
      和数个位    待定
      !output!    (=某数甲 =某数乙 =某数丙 =某数丁)
  )

  (goal-focus 36+47)
)