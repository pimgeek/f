; pimflow main
; by pimgeek

; need a function to clear memory
; prepare for gui env
(use 'clojure.repl)
(use 'seesaw.core)
(use 'seesaw.dev)
(native!)
(defn p [frame ui] 
  (config! frame :content ui
    )
  )
(defn v [frame]
  (-> frame pack! show!
    )
  )
  
; define main frame and its widgets

(def main-frm (frame :title "Flow"))
(def trigger-btn (button :text "Open"))
(p main-frm trigger-btn)
(v main-frm)