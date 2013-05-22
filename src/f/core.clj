; pimflow main
; by pimgeek
; 
; setup namespace
(ns f.core           ; with trptcolin's help and his blog post.
  (:use
    [clojure.repl]
    [seesaw.core]
    [seesaw.mig]
    [seesaw.dev]
  )
)
;
; setup util functions 
(defn p [frame ui]    ; put ui on frame
  (config! frame :content ui
  )
)
(defn v [frame]       ; make the frame visible
  (-> frame pack! show!
  )
)
  
; define main frame and its widgets

(defn run-app []
  (native!)
  (def main-frm (frame :title "Flow"))
  (def trigger-btn (button :text "Open"))
  (def prev-btn (button :text "上一步"))
  (def next-btn (button :text "下一步"))
;  (def mpanel
;    (mig-panel
;      :constraints ["wrap 2"
;      ]
;      :items [
;        [trigger-btn "wrap"]
;      ]
;    )
;  )
; (add! mpanel ["2nd" "wrap"])
; (add! mpanel ["3rd"])
  (def bpanel (border-panel
    :north trigger-btn
    :center (label :text "这条笔记很有用")
    :west prev-btn
    :east next-btn
    :south (label :text "tag1, tag2, tag3")
    :border 3
    :vgap 50 :hgap 50 :border 15))
  (p main-frm bpanel)
  (v main-frm)
)
