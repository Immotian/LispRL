(defpackage :lisprl
  (:use #:cl #:cl-charms))
(in-package :lisprl)
;(setf *error-output* *temp-stdout*)

;;Reminder: printw and similar take integer arguments; CL's division != integer division
(defun main(argv)

;I had trouble with the map and room becoming visited all at once -- the problem was caused by :initial-element [object] creating shallow copies, so I had to iterate over each entry and set that entry to a new tile object.
;(defparameter *map* (make-array (list *map-max-x* *map-max-y*)))
(dotimes (x (array-dimension *map* 0))
  (dotimes (y (array-dimension *map* 1))
    (setf (aref *map* x y)
	  (make-instance 'tile :pass nil :opaque t :char #\# :visit nil :color COLOR_BLUE))))

(defparameter *room* (make-instance 'rect :x 3 :y 3 :dx 20 :dy 20))

(make-room *room* *map*)

(init)

(setf (aref *map* 5 17) (make-instance 'tile :pass nil :opaque t :char #\# :color COLOR_CYAN))

(unwind-protect
     (while *running*
       (draw-world)

       (let ((input (code-char (getch))))
	 
	 (handle-input input)))
  
  (kill))
)
