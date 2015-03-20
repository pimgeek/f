;; -*- coding:utf-8 -*- ;;
(clear-all)

(define-model 生物对象归类认知模型
  ; 参数设置
  (sgp :esc t :lf .05 :trace-detail high) ;; :trace-filter production-firing-only)
  
  (chunk-type 属性描述 生物对象 属性名称 取值)
  (chunk-type 类别归属 生物对象 生物类别 类别判定结果)
  
  (add-dm
    (鲨鱼 isa chunk) (危险 isa chunk)
    (运动方式 isa chunk) (游泳 isa chunk) 
    (鱼类 isa chunk) (鲑鱼 isa chunk)
    (可食用 isa chunk) (呼吸方式 isa chunk)
    (鳃 isa chunk) (动物 isa chunk)
    (可移动 isa chunk) (皮肤 isa chunk)
    (金丝雀 isa chunk) (颜色 isa chunk) (黄色 isa chunk)
    (唱歌 isa chunk) (鸟类 isa chunk) 
    (鸵鸟 isa chunk) (有飞行能力 isa chunk) 
    (身高 isa chunk) (高 isa chunk)
    (翅膀 isa chunk) (飞行 isa chunk) 
    (是 isa chunk) (非 isa chunk) (生物类别 isa chunk)
    (待定 isa chunk) (可判定 isa chunk) (不可判定 isa chunk)
    (p1 ISA 属性描述 生物对象 鲨鱼 属性名称 危险 取值 是)
    (p2 ISA 属性描述 生物对象 鲨鱼 属性名称 运动方式 取值 游泳)
    (p3 ISA 属性描述 生物对象 鲨鱼 属性名称 生物类别 取值 鱼类)
    (p4 ISA 属性描述 生物对象 鲑鱼 属性名称 可食用 取值 是)
    (p5 ISA 属性描述 生物对象 鲑鱼 属性名称 运动方式 取值 游泳)
    (p6 ISA 属性描述 生物对象 鲑鱼 属性名称 生物类别 取值 鱼类)
    (p7 ISA 属性描述 生物对象 鱼类 属性名称 呼吸方式 取值 鳃)
    (p8 ISA 属性描述 生物对象 鱼类 属性名称 运动方式 取值 游泳)
    (p9 ISA 属性描述 生物对象 鱼类 属性名称 生物类别 取值 动物)
    (p10 ISA 属性描述 生物对象 动物 属性名称 可移动 取值 是)
    (p11 ISA 属性描述 生物对象 动物 属性名称 皮肤 取值 是)
    (p12 ISA 属性描述 生物对象 金丝雀 属性名称 颜色 取值 黄色)
    (p13 ISA 属性描述 生物对象 金丝雀 属性名称 唱歌 取值 是)
    (p14 ISA 属性描述 生物对象 金丝雀 属性名称 生物类别 取值 鸟类)
    (p15 ISA 属性描述 生物对象 鸵鸟 属性名称 有飞行能力 取值 非)
    (p16 ISA 属性描述 生物对象 鸵鸟 属性名称 身高 取值 高)
    (p17 ISA 属性描述 生物对象 鸵鸟 属性名称 生物类别 取值 鸟类)
    (p18 ISA 属性描述 生物对象 鸟类 属性名称 翅膀 取值 是)
    (p19 ISA 属性描述 生物对象 鸟类 属性名称 运动方式 取值 飞行)
    (p20 ISA 属性描述 生物对象 鸟类 属性名称 生物类别 取值 动物)
    (g1 ISA 类别归属 生物对象 金丝雀 生物类别 鸟类 类别判定结果 nil)
    (g2 ISA 类别归属 生物对象 金丝雀 生物类别 动物 类别判定结果 nil)
    (g3 ISA 类别归属 生物对象 金丝雀 生物类别 鱼类 类别判定结果 nil))
  
  (p initial-retrieve
    =goal>
      ISA            类别归属
      生物对象       =某生物对象
      生物类别       =生物类别
      类别判定结果   nil
  ==>
    =goal>
      类别判定结果   待定
    +retrieval>      
      ISA            属性描述
      生物对象       =某生物对象
      属性名称       生物类别
  )

  (P direct-verify
    =goal>
      ISA            类别归属
      生物对象       =某生物对象
      生物类别       =生物类别
      类别判定结果   待定
    =retrieval>      
      ISA            属性描述
      生物对象       =某生物对象
      属性名称       生物类别
      取值           =生物类别
  ==>                
    =goal>           
      类别判定结果   可判定
      !output!       (=某生物对象)
      !output!       (=生物类别)
  )
  
  (P chain-生物类别
    =goal>
      ISA            类别归属
      生物对象       =生物对象甲
      生物类别       =生物类别
      类别判定结果   待定
    =retrieval>      
      ISA            属性描述
      生物对象       =生物对象甲
      属性名称       生物类别
      取值           =生物对象乙
      - 取值         =生物类别
  ==>                
    =goal>           
      生物对象       =生物对象乙
    +retrieval>      
      ISA            属性描述
      生物对象       =生物对象乙
      属性名称       生物类别
  )
  
  (P fail
    =goal>
       ISA           类别归属
       生物对象      =生物对象甲
       生物类别      =生物类别  
       类别判定结果  待定

     ?retrieval>
       state         error
  ==>                
    =goal>           
      类别判定结果   不可判定
      !output!       (=生物对象甲)
      !output!       ("无法判定此生物对象的类别归属...")
  )
  (goal-focus g3))