(clear-all)

(define-model 简单加法运算认知模型
  ; 参数设置
  (sgp :esc t :lf .05 :trace-detail high) ;; :trace-filter production-firing-only)

  ;; Add Chunk-types here
  (chunk-type 10_10-简单加法规则 简单被加数 简单加数 简单和数)
  (chunk-type 简单加法运算工作 简单被加数 简单加数 简单和数)
  
  ;; Add Chunks here
  (add-dm
    (待定 isa chunk)
    (0_0-规则 isa 10_10-简单加法规则 简单被加数 0 简单加数 0 简单和数 0)
    (0_1-规则 isa 10_10-简单加法规则 简单被加数 0 简单加数 1 简单和数 1)
    (1_0-规则 isa 10_10-简单加法规则 简单被加数 1 简单加数 0 简单和数 1)
    (1_1-规则 isa 10_10-简单加法规则 简单被加数 1 简单加数 1 简单和数 2)
    (简单加法运算实例 isa 简单加法运算工作 简单被加数 11 简单加数 10 简单和数 nil)
    )
  
  ;; Add productions here
  (p 加法运算初始
    =goal>
      isa         简单加法运算工作
      简单被加数  =某数甲
      简单加数    =某数乙
      简单和数    nil
  ==>
    =goal>
      简单和数    待定
    +retrieval>
      isa         10_10-简单加法规则
      简单被加数  =某数甲
      简单加数    =某数乙
      !output!    (=某数甲 =某数乙)
  )
  
  (p 加法运算过程
    =goal>
      isa         简单加法运算工作
      简单被加数  =某数甲
      简单加数    =某数乙
      简单和数    待定
    =retrieval>
      isa         10_10-简单加法规则
      简单被加数  =某数甲
      简单加数    =某数乙
      简单和数    =某数丙
  ==>
    =goal>
      简单和数    =某数丙
      !output!    (=某数丙)
  )
  
  (goal-focus 简单加法运算实例)
)