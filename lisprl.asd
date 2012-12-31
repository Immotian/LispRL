;;;; lisprl.asd

(require 'asdf)


    ;; Additional places where ASDF can find
    ;; system definition files
(asdf:defsystem #:lisprl
  :serial t
  :description "A simple roguelike written in Common Lisp"
  :author "Immotian"
  :license "GPL 3"
  :depends-on (#:cl-charms)
  :components ((:file "package")
	       (:file "tile")
	       (:file "globals")
	       (:file "gamesave")
	       (:file "room")
	       (:file "object")
	       (:file "creature")
	       ;(:file "object")
	       (:file "utilities")
	       (:file "lisprl")))
