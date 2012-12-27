;;;; package.lisp
;;I'll strip out the quicklisp initialization and quickload when I get ASDF working properly.
;;

#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp"
                                       (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(ql:quickload :cl-charms)

(defpackage #:lispRL
  (:use #:cl #:cl-charms))
