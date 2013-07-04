#!/usr/bin/clojure

; pimflow listing notes
; by pimgeek
; 
; setup namespace
(ns f.core           ; with trptcolin's help and his blog post.
  (:use
    [clojure.repl]
    [clojure.java.io]
  )
  (:gen-class :main true)
)

; get the list of note files by path
;
; need to have edge condition verification
(defn list-notes [path]
  (def fnames
    (for 
      [x (file-seq (file path))]
      (.getPath x)
    )
  )
  (doseq [x fnames]
    (prn x)
  )
)

; test running
(list-notes "/home/pimgeek/pim-wudi/_play/notes")

