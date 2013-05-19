; pimflow main
; by pimgeek

; need a function to clear memory
; prepare for gui env
(load-file "pre.clj")

; define main frame and its widgets
(def main-frm (frame :title "Flow"))
(def trigger-btn (button :text "Open"))
(p main-frm trigger-btn)
(v main-frm)
