;; -*- coding:utf-8 -*- ;;
(clear-all)

(define-model 连续数若干个数的认知模型
  ; 参数设置
  (sgp :esc t :lf .05 :trace-detail medium) ;; :trace-filter production-firing-only)
  
  (chunk-type 顺次相邻的数对 较小的数 较大的数)
  (chunk-type 完成连续数若干个数的任务 开始时的数 结束时的数 刚数过的数)

  (add-dm
    (一到二 ISA 顺次相邻的数对 较小的数 1 较大的数 2)
    (二到三 ISA 顺次相邻的数对 较小的数 2 较大的数 3)
    (三到四 ISA 顺次相邻的数对 较小的数 3 较大的数 4)
    (四到五 ISA 顺次相邻的数对 较小的数 4 较大的数 5)
    (五到六 ISA 顺次相邻的数对 较小的数 5 较大的数 6)
    (主要目标 ISA 完成连续数若干个数的任务 开始时的数 2 结束时的数 6))

  (p 开始数数
    =goal>
      ISA           完成连续数若干个数的任务
      开始时的数    =某数甲
      刚数过的数    nil
   ==>                
    =goal>           
      刚数过的数    =某数甲
    +retrieval>    
      ISA           顺次相邻的数对
      较小的数      =某数甲
    !output!        ("执行说明：交给 ACT-R 的任务要求是 - 从 2 数到 6")
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
  (goal-focus 主要目标))
