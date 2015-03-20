;; -*- coding:utf-8 -*- ;;

(load "./actr61/load-act-r-6.lisp")
(defvar target-model "count_cn")
(load (format nil "p:/pim-wudi/_dev/mind/f/info/actr/~A.lisp" target-model))
(defvar output-path (format nil "p:/pim-wudi/_dev/mind/f/info/actr/~A.out" target-model))
(load "./quicklisp/setup.lisp")
(ql:quickload :asdf)
(ql:quickload :cl-ppcre)
(defvar mdl-out)
(defvar mdl-out-lst)
(defvar flted-mdl-out-lst)
(defvar flted-mdl-out-str)
(setf mdl-out
  (capture-model-output (run 1)))
(setf mdl-out-lst 
  (cl-ppcre:split "[\\r\\n]+" mdl-out))
(setf flted-mdl-out-lst
  (remove-if-not (lambda (v) (not (null v)))
  (map 'list (lambda (x) (cl-ppcre:scan-to-strings "^[^ ].+$" x)) mdl-out-lst)))
(defun str-lst-print (&rest strings)
  (let ((output-str ""))
    (dolist (str strings)
      (setf output-str (concatenate 'string output-str (format nil "[~A]~%" str))))
    output-str))
(setf flted-mdl-out-str
  (apply
    #'str-lst-print flted-mdl-out-lst))
(with-open-file
  (out (pathname output-path)
    :direction :output 
    :if-exists :supersede)
  (write-line flted-mdl-out-str out))
(clear-all)
(exit)
