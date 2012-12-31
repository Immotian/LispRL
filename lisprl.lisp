(in-package :lisprl)

(defparameter *running* t)
(setf *error-output* (open #P"error.txt" :direction :output :if-exists :supersede :if-does-not-exist :create))
;;(setf *debug-io* (open #P"testerror.txt" :direction :io :if-exists :supersede :if-does-not-exist :create))


;;Reminder: printw and similar take integer arguments; CL's division != integer division

;;I had trouble with the map and room becoming visijted all at once -- the problem was caused by :initial-element [object] creating shallow copies, so I had to iterate over each entry and set that entry to a new tile object.
;;(defparameter *map* (make-array (list *map-max-x* *map-max-y*)))


(defparameter *room* (make-instance 'rect :x 3 :y 3 :dx 20 :dy 20))

(make-room *room* *map*)



;;(setf (aref *map* 5 17) (make-instance 'tile :pass nil :opaque t :char #\# :color COLOR_CYAN))
(handler-case
    (unwind-protect
	 (progn
	   (init)
	   (loop while *running* do
		;(getch)
		(draw-world)
		(tick *time-deque*)))
      
      (endwin))
  (error (e) (error e)))
