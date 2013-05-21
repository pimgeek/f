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
  (def main-frm (frame :title "Flow"))
  (def trigger-btn (button :text "Open"))
  (def mpanel
    (mig-panel
      :constraints ["wrap 2"
      ]
      :items [
        [trigger-btn "wrap"]
      ]
    )
  )
  (add! mpanel ["2nd" "wrap"])
  (add! mpanel ["3rd"])
  (def bpanel (border-panel
    :north trigger-btn
    :center (label :text "center")
    :west (label :text "west")
    :east (label :text "east")
    :south (label :text "source")
    :border [5 "dashed" 10]
    :vgap 50 :hgap 50 :border 15))
  (p main-frm bpanel)
  (v main-frm)
)
