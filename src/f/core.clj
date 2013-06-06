                                        ; pimflow main
                                        ; by pimgeek
                                        ; 
                                        ; setup namespace
(ns f.core           ; with trptcolin's help and his blog post.
  (:use
   [clojure.repl]
   [seesaw.core]
   [seesaw.dev]
   [seesaw.graphics]
   )
  (:gen-class :main true)
  )
                                        ; setup util functions 

(defn p [frame ui]    ; put ui on frame
  (config! frame :content ui
           )
  )
(defn v [frame]       ; make the frame visible
  (-> frame pack! show!
      )
  )
                                        ; get the list of note files
(defn my-ls [path]
  (doseq [res (.listFiles (File. path))]
    (println (.getName res))
    )
  )

                                        ; read the file list into gui
                                        ; define main frame and its widgets

(defn run-app []
  (native!)
  (def m-frm (frame :title "Flow" :minimum-size [800 :by 600] ))
  (def lid-btn (button :text "Open"))
  (def prev-btn (button :text "上一步"))
  (def next-btn (button :text "下一步"))
  (defn note-rect [c g]
    (let [w          (width  c)
          h          (height c)
          line-style (style :foreground "#333333" :stroke 3 :cap :round)
          d          5]
      (draw g
            (rounded-rect 10 10 240 180 25 25) 
            line-style
            )
      )
    )
  (def m-cvs (canvas))
  (config! m-cvs :paint note-rect)
  (def m-panel (border-panel
                :north lid-btn
                :center (label :text "这条笔记很有用")
                :west prev-btn
                :east next-btn
                :south (label)
                :border 3
                :vgap 50 :hgap 50 :border 15))
  (def m-sp
    (top-bottom-split
     (scrollable m-panel)
     (scrollable m-cvs)
     )
    )
  (p m-frm m-sp)
  (v m-frm)
  )

(defn -main [] (run-app))  ; setup main function   