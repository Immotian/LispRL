(in-package :lisprl)

(defun init ()
  "Whatever needs to be done before the game loop"
  (initscr)
  (raw)
  (noecho)
  (curs-set 0)
  (getmaxyx *stdscr* *screen-y* *screen-x*)
  #|(setf *player* (make-instance 'creature
				:name "Player"
				:x 15
				:y 15
				:char #\@
				:ai #'player
				:hp 20
				:mhp 20
				:str 3
				:speed 100
				:ap 0
				:ally 'player))|#
  (register-object *player* *time-deque*)
  (defparameter *creature* (make-instance 'creature
		       :name "Foo"
		       :x 5
		       :y 9
		       :char #\x
		       :ai #'aggressor
		       :hp 10
		       :mhp 10
		       :str 1
		       :speed 100
		       :ap 0
		       :ally 'monsters
		       :turn-started nil))
  (register-object *creature* *time-deque*)
  
  (push *creature* *creature-list*)
  (init-colors))

;;from http://www.pvv.ntnu.no/~eirikald/repos/bzr/cl-ncurses/tests/advocacy.lisp
(defun init-colors ()
  (start-color)
  (init-pair COLOR_BLACK   COLOR_BLACK   COLOR_BLACK)
  (init-pair COLOR_GREEN   COLOR_GREEN   COLOR_BLACK)
  (init-pair COLOR_RED     COLOR_RED     COLOR_BLACK)
  (init-pair COLOR_CYAN    COLOR_CYAN    COLOR_BLACK)
  (init-pair COLOR_WHITE   COLOR_WHITE   COLOR_BLACK)
  (init-pair COLOR_MAGENTA COLOR_MAGENTA COLOR_BLACK)
  (init-pair COLOR_BLUE    COLOR_BLUE    COLOR_BLACK)
  (init-pair COLOR_YELLOW  COLOR_YELLOW  COLOR_BLACK))


(defun draw-map (map)
  (dotimes (x (array-dimension map 0))
    (dotimes (y (array-dimension map 1))
      (let ((current-tile (aref map x y)))
	(if (is-tile-visible *player* x y *map*)
	    (draw-tile current-tile x y)
	    (if (tile-visit current-tile)
		(draw-visited current-tile x y)))))))


(defun draw-world ()
  (clear)
  (draw-map *map*)
  (mapcan #'draw *objects*)
  (mapcan #'draw *creature-list*)
  (draw *player*)
  (print-messages *message-list* *max-display-message* *message-box-x* *message-box-y*)
  ;;(draw-bresenham *player* (car *creature-list*) *map*)
  (refresh))

(defun kill ()
  "Cleans up after game loop finishes"
  (endwin)
  (save-everything))

(defun int-div (num denom)
  "Integer division. Rounds down."
  (floor (/ num denom)))

(defmacro while (condition &body body)
  `(loop while ,condition
      do (progn ,@body)))

(defun handle-input (input)
  (let ((delta-x 0) (delta-y 0))
    (case input
      (#\h (decf delta-x))
      (#\j (incf delta-y))
      (#\k (decf delta-y))
      (#\l (incf delta-x))
      (#\x (if (< *los-radius* 10)
	       (setf *los-radius* 10)
	       (setf *los-radius* 7)))
      (#\q (setf *running* nil)))
    (move-thing *player* delta-x delta-y *map*)
    (mapcan #'act *creature-list*)))

;;(defun in-map (x y map)
;;  (print object)
;; (if (and (< x (array-dimension map 0))
;;	   (>= x 0)
;;	   (< y (array-dimension map 1))
;;        (>= y 0))
;;     t
;;      nil))


;;This and is-tile-visible were lifted from Wikipedia
#|(defmethod draw-bresenham ((viewing-object object) (object object) map)
  (let* ((x0 (object-x viewing-object))
	 (y0 (object-y viewing-object))
	 (x1 (object-x object))
	 (y1 (object-y object))
	 (steep (> (abs (- y1 y0))
		   (abs (- x1 x0)))))
    (if steep
	(progn
	  (rotatef x0 y0)
	  (rotatef x1 y1)))
    (if (> x0 x1)
	(progn
	  (rotatef x0 x1)
	  (rotatef y0 y1)))
    (let* ((dx (- x1 x0))
	   (dy (abs (- y1 y0)))
	   (line-error (floor (/ dx 2)))
	   (ystep (if (< y0 y1)
		      1
		      -1))
	   (y y0))
      (loop for x from x0 to x1 do
	   (progn
	     (print steep)
	     (if steep
		 (if (tile-opaque (aref map y x))
		     nil)
		 (if (tile-opaque (aref map x y))
		     nil))
	     (setf line-error (- line-error dy))
	     ;;(print x1)
	     (if (< line-error 0)
		 (progn
		   (setf y (+ y ystep))
		   (setf line-error (+ line-error dx))))
	     (if steep
		 (move x y)
		 (move y x))
	     (addch (+ 97 x))))
      t)))|#

(defmethod is-tile-visible ((viewing-object object) tile-x tile-y map)
  (let* ((x0 (object-x viewing-object))
	 (y0 (object-y viewing-object))
	 (x1 tile-x)
	 (y1 tile-y)
	 (steep (> (abs (- y1 y0))
		   (abs (- x1 x0)))))
    (if steep
	(progn
	  (rotatef x0 y0)
	  (rotatef x1 y1)))
    (if (> x0 x1)
	(progn
	  (rotatef x0 x1)
	  (rotatef y0 y1)))
    (let* ((dx (- x1 x0))
	   (dy (abs (- y1 y0)))
	   (line-error (floor (/ dx 2)))
	   (ystep (if (< y0 y1)
		      1
		      -1))
	   (y y0))
      (if (< *los-radius* (sqrt (+ (expt dx 2)
				   (expt dy 2))))
	  (return-from is-tile-visible nil))
      (loop for x from x0 to x1 do
	   (if steep
	       (if (and (= x tile-y) (= y tile-x))
		   t
		   (if (tile-opaque (aref map y x))
		       (return-from is-tile-visible nil)))
	       (if (and (= x tile-x) (= y tile-y))
		   t
		   (if (tile-opaque (aref map x y))
		       (return-from is-tile-visible nil))))
	   (setf line-error (- line-error dy))
	   (if (< line-error 0)
	       (progn
		 (setf y (+ y ystep))
		 (setf line-error (+ line-error dx)))))
      t)))

(defun add-message (message)
  (push message *message-list*))

(defun print-messages (message-list num-messages x y)
  "Print messages in the message area, most recent descending."
  (let ((num-print (min num-messages (length message-list))))
    (dotimes (i num-print)
      (mvprintw (+ y i)
		x
		(nth (- num-print i 1) message-list)))))

