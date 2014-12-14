;; -*- coding:utf-8 -*- ;;
(clear-all)

(define-model 两个数相加的认知模型
  ; 参数设置
  (sgp :esc t :lf .05 :trace-detail low) ;; :trace-filter production-firing-only)
  
  (chunk-type 顺次相邻的数对 较小的数 较大的数)
  (chunk-type 两个数的加法 被加数 加数 和数 当前数到的数)

  (add-dm
    (a ISA 顺次相邻的数对 较小的数 0 较大的数 1)
    (b ISA 顺次相邻的数对 较小的数 1 较大的数 2)
    (c ISA 顺次相邻的数对 较小的数 2 较大的数 3)
    (d ISA 顺次相邻的数对 较小的数 3 较大的数 4)
    (e ISA 顺次相邻的数对 较小的数 4 较大的数 5)
    (f ISA 顺次相邻的数对 较小的数 5 较大的数 6)
    (g ISA 顺次相邻的数对 较小的数 6 较大的数 7)
    (h ISA 顺次相邻的数对 较小的数 7 较大的数 8)
    (i ISA 顺次相邻的数对 较小的数 8 较大的数 9)
    (j ISA 顺次相邻的数对 较小的数 9 较大的数 10)
    (模型目标 ISA 两个数的加法 被加数 5 加数 4))

  (P 加法初始
    =goal>
      ISA              两个数的加法
      被加数           =数字甲
      加数             =数字乙
      和数              nil
  ==>                  
    =goal>             
      和数             =数字甲
      当前数到的数       0
      !output!         (=数字甲)
      !output!         (=数字乙)
    +retrieval>        
      isa              顺次相邻的数对
      较小的数         =数字甲
  )                    
                       
  (P 加法终止          
    =goal>             
      ISA              两个数的加法
      当前数到的数     =某个数字
      加数             =某个数字
      和数             =最终和数
  ==>                  
    =goal>             
      当前数到的数     nil
      !output!         (=最终和数)
  )                    
                       
  (P 增大当前数到的数  
    =goal>             
      ISA              两个数的加法
      和数             =和数
      当前数到的数     =当前数到的数
    =retrieval>        
      ISA              顺次相邻的数对
      较小的数         =当前数到的数
      较大的数         =下一步数到几
  ==>                  
    =goal>             
      当前数到的数     =下一步数到几
    +retrieval>        
      isa              顺次相邻的数对
      较小的数         =和数
  )                    
                       
  (P 增大和数          
    =goal>             
      ISA              两个数的加法
      和数             =和数
      当前数到的数     =当前数到的数
      - 加数           =当前数到的数
    =retrieval>        
      ISA              顺次相邻的数对
      较小的数         =和数
      较大的数         =下一步的和数
  ==>                  
    =goal>             
      和数             =下一步的和数
    +retrieval>        
      isa              顺次相邻的数对
      较小的数         =当前数到的数
  )

  (goal-focus 模型目标)
)
