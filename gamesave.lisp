(in-package :lisprl)

(defun save-everything ()
  (with-open-file (*standard-output* #p"save.txt" :direction :output :if-exists :supersede :if-does-not-exist :create)
    (mapcan #'print (list *player* *objects* *map-max-x* *map-max-y* *map* *los-radius* *message-box-x* *message-box-x* *message-list* *max-display-message*))))

(defun load-everything ()
  (with-open-file (*standard-input* #p"save.txt" :direction :input)
    (mapcan #'read (list *player* *objects* *map-max-x* *map-max-y* *map* *los-radius* *message-box-x* *message-box-x* *message-list* *max-display-message*))))

(defmethod print-object ((tile tile) stream)
	   (format t "~a" (code-char (tile-char tile))))

#|(defmethod print-object ((object (eql *map*)) stream)
  (dotimes (x (array-dimension object 0))
    (dotimes (y (array-dimension object 1))
      (print (aref object x y)))))|#
