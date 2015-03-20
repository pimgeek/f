;; -*- coding:utf-8 -*- ;;
(clear-all)

(define-model 自适应导学认知模型
  ;; 参数设置
  (sgp :esc t :lf .05 :trace-detail low)
  ;; chunk-type 设置
  (chunk-type 新技能整体贯通目标类
    技能名称 技能细部数 技能贯通数 技能贯通率)
  (chunk-type 新技能单步贯通目标类
    技能名称 技能细部序号 是否贯通)
  ;; chunk 设置
  (add-dm
    (打开-google-首页 isa chunk)
    (打开网页浏览器 isa chunk))
    
  (add-dm
    ;; 模型目标
    (首要目标 isa 新技能整体贯通目标类
	    技能名称 打开-google-首页
      技能细部数 4
      技能贯通数 0))
  (p 技能培训初始动作
    =goal>
      isa           新技能整体贯通目标类
      技能名称      =某技能甲
      技能细部数    =某技能细部数
      技能贯通数    =某技能贯通数
      技能贯通率    nil
  ==>
    !bind!          =through_rate (/ =某技能贯通数 (+ 0.0 =某技能细部数))
    =goal>
      技能贯通率    =through_rate
      !output!      (开始培训 -> =某技能甲 =through_rate)
  )
  (p 技能贯通细分动作-1
    =goal>
      isa           新技能整体贯通目标类
      技能名称      =某技能甲
      技能贯通率    0.0
  ==>
    +goal>
      isa           新技能单步贯通目标类
      技能名称      =某技能甲
      技能细部序号  1
      是否贯通      nil
      !output!      (寻找培训入手点 -> =某技能甲)
  )
  (p 技能细部贯通动作
    =goal>
      isa           新技能单步贯通目标类
      技能名称      =某技能甲
      技能细部序号  =某技能细部序号
      是否贯通      nil
  ==>
    =goal>
      
  )
  (goal-focus 首要目标)
)
