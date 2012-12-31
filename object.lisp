(in-package :lisprl)

(defclass object ()
  ((name :accessor object-name :initarg :name)
   (x :accessor object-x :initarg :x)
   (y :accessor object-y :initarg :y)
   (character :initarg :char)
   (speed :accessor object-speed :initarg :speed)
   (ap :accessor object-ap :initarg :ap)
   (turn-started :accessor object-turn-started :initarg :turn-started)))

(defmethod object-char ((object object))
  (char-code (slot-value object 'character)))

(defun in-map (x y map)
  (if (and (< x (array-dimension map 0))
	   (>= x 0)
	   (< y (array-dimension map 1))
	   (>= y 0))
      t
      nil))

(defmethod move-thing ((object object) dx dy map)
  (let ((new-x (+ (object-x object) dx))
	(new-y (+ (object-y object) dy)))
    (if (and (in-map new-x new-y map)
	     (tile-passable (aref map new-x new-y)))
	(progn
	  (setf (object-x object) new-x)
	  (setf (object-y object) new-y)
	  t)
	nil)))

(defmethod draw ((object object))
  (if (is-visible *player* object *map*)
      (progn
	(move (object-y object) (object-x object))
	(addch (object-char object)))))

(defmethod is-visible ((viewing-object object) (object object) map)
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
      (if (< *los-radius* (sqrt (+ (expt dx 2)
				   (expt dy 2))))
	  (return-from is-visible nil))
      (loop for x from x0 to x1 do
	   (if steep
	       (if (tile-opaque (aref map y x))
		   (return-from is-visible nil))
	       (if (tile-opaque (aref map x y))
		   (return-from is-visible nil)))
	   (setf line-error (- line-error dy))
	   (if (< line-error 0)
	       (progn
		 (setf y (+ y ystep))
		 (setf line-error (+ line-error dx)))))
      t)))

(defmacro register-object (object time-deque)
  `(push ,object ,time-deque))

(defmethod release-object ((object object) time-deque)
  (delete object time-deque))

(defun rotate-left (rlist)
  "Non-destructively returns a rotated list (positive parameter rotates to left)"
  (nconc (cdr rlist) (list (car rlist))))



(defun set-list (to from)
  "Destructively copies from into to. Stops at the end of either parameter."
  (if (and (car to) (car from))
      (progn
	(setf (car to) (car from))
	(set-list (cdr to) (cdr from)))))

(defun rotate (list count)
  (if (minusp count)
      (rotate list (+ (length list) count))
      (nconc (subseq list count) (subseq list 0 count))))


(defun tick (time-deque)
  (if time-deque
      (let* ((object (car time-deque))
	     (ap (object-ap object))
	     (speed (object-speed object))
	     (turn-started (object-turn-started object)))
	(if (not turn-started)
	    (progn
	      (setf (object-ap object) (+ ap speed))
	      (setf (object-turn-started object) t)))

	
	(if (> (object-ap object) 0)
	    
	    (let ((action (act object)))
	      (if (not (eq action 'no-move))
		  (setf (object-ap object)
			(- (object-ap object)
			   action))))
	    (progn	      
	      (setf (object-turn-started object) nil)
	      (set-list time-deque (rotate time-deque 1)))))
      
      (error "Time deque is empty")))
