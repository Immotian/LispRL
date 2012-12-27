(in-package :lispRL)

(defclass rect ()
  ((x :accessor rect-x :initarg :x)
   (y :accessor rect-y :initarg :y)
   (dx :accessor rect-dx :initarg :dx)
   (dy :accessor rect-dy :initarg :dy)))

(defmethod make-room ((rect rect) map)
  (dotimes (length (rect-dx rect))
    (dotimes (height (rect-dy rect))
      (setf (aref map
		  (+ length (rect-x rect))
		  (+ height (rect-y rect)))
	    (make-instance 'tile :pass t :opaque nil :char (char-code #\.) :color COLOR_GREEN)))))
