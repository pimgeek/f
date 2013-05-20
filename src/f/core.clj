; pimflow main
; by pimgeek

(ns f.core
  (:use
    [clojure.repl]
    [seesaw.core]
    [seesaw.dev]
	)
  )

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