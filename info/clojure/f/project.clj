(defproject f "0.1.0-SNAPSHOT"
  :description "笔记流"
  :url "tbd"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"
           }
  :dependencies [[org.clojure/clojure "1.5.1"] 
                 [seesaw "1.4.3"] 
                 [org.clojure/tools.cli "0.2.2"]
                ]
  :plugins [[lein-exec "0.3.0"]]
  :main f.core
)
