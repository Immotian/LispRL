;(defparameter *temp-stdout* *error-output*)
(setf *error-output* (open "./error.txt" :if-exists :supersede :if-does-not-exist :create :direction :output))
(load "package.lisp")
(load "object.lisp")
(load "utilities.lisp")
(load "tile.lisp")
(load "room.lisp")
(load "gamesave.lisp")
;(setf *error-output* *temp-stdout*)

;;Reminder: printw and similar take integer arguments; CL's division != integer division

(in-package :lispRL)

(defparameter *screen-y* 0)
(defparameter *screen-x* 0)
(defparameter *player* nil)
(defparameter *objects* nil)
(defparameter *running* t)
(defparameter *map-max-x* 80)
(defparameter *map-max-y* 25)

;I had trouble with the map and room becoming visited all at once -- the problem was caused by :initial-element [object] creating shallow copies, so I had to iterate over each entry and set that entry to a new tile object.
(defparameter *map* (make-array (list *map-max-x* *map-max-y*)))

(dotimes (x (array-dimension *map* 0))
  (dotimes (y (array-dimension *map* 1))
    (setf (aref *map* x y)
	  (make-instance 'tile :pass nil :opaque t :char (char-code #\#) :visit nil :color COLOR_BLUE))))

(defparameter *los-radius* 7)
(defparameter *message-box-y* 0)
(defparameter *message-box-x* (+ 2 *map-max-x*))
(defparameter *message-list* nil)
(defparameter *max-display-message* 5)

(defparameter *room* (make-instance 'rect :x 3 :y 3 :dx 20 :dy 20))

(make-room *room* *map*)

(init)

(setf (aref *map* 5 17) (make-instance 'tile :pass nil :opaque t :char (char-code #\#) :color COLOR_CYAN))

(unwind-protect
     (while *running*
       (draw-world)

       (let ((input (code-char (getch))))
	 
	 (handle-input input)))
  
  (kill))
