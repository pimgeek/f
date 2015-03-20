(clear-all)

(define-model 连续数若干个数的认知模型
  ; 参数设置
  (sgp :esc t :lf .05 :trace-detail low :trace-filter production-firing-only)
  
  (chunk-type 顺次相邻的数对 较小的数 较大的数)
  (chunk-type 完成连续数若干个数的任务 开始时的数 结束时的数 刚数过的数)

  (add-dm
    (一到二 ISA 顺次相邻的数对 较小的数 一 较大的数 二)
    (二到三 ISA 顺次相邻的数对 较小的数 二 较大的数 三)
    (三到四 ISA 顺次相邻的数对 较小的数 三 较大的数 四)
    (四到五 ISA 顺次相邻的数对 较小的数 四 较大的数 五)
    (五到六 ISA 顺次相邻的数对 较小的数 五 较大的数 六)
    (首要目标 ISA 完成连续数若干个数的任务 开始时的数 二 结束时的数 六))

  (p 开始数数
    =goal>
      ISA         完成连续数若干个数的任务
      开始时的数  =某数甲
      刚数过的数  nil
   ==>                
    =goal>           
      刚数过的数    =某数甲
    +retrieval>    
      ISA           顺次相邻的数对
      较小的数      =某数甲
  )                

  (P 往后数一个数       
    =goal>         
      ISA           完成连续数若干个数的任务
      刚数过的数    =某数甲
      - 结束时的数  =某数甲
    =retrieval>    
      ISA           顺次相邻的数对
      较小的数      =某数甲
      较大的数      =某数乙
   ==>                
    =goal>           
      刚数过的数    =某数乙
    +retrieval>      
      ISA           顺次相邻的数对
      较小的数      =某数乙
      !output!      (=某数甲)
  )                 

  (P 停止数数       
    =goal>         
      ISA           完成连续数若干个数的任务
      刚数过的数    =某数丙
      结束时的数    =某数丙
   ==>              
      -goal>        
      !output!      (=某数丙)
  )

  (goal-focus 首要目标))
