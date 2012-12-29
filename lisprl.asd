;;;; lisprl.asd

(require 'asdf)

#|
#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp"
                                       (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(ql:quickload :cl-charms)
;(require :sb-posix)
   ;; Default directories, usually just the ``current directory''
|#

    ;; Additional places where ASDF can find
    ;; system definition files
(asdf:defsystem #:lisprl
  :serial nil
  :description "A simple roguelike written in Common Lisp"
  :author "Immotian"
  :license "GPL 3"
  :depends-on (#:cl-charms)
  :components ((:file "package")
	       (:file "globals" :depends-on ("package"))
	       (:file "tile" :depends-on ("globals"))
	       (:file "gamesave" :depends-on ("package" "tile"))
	       (:file "room" :depends-on ("globals" "package"))
	       (:file "object" :depends-on ("globals" "package"))
	       (:file "creature" :depends-on ("globals" "package" "object"))
	       (:file "utilities" :depends-on ("globals" "package" "object" "creature"))
	       (:file "lisprl" :depends-on ("package" "tile" "room" "utilities" "globals" "gamesave"))))
