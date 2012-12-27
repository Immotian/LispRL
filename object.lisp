(in-package :lisprl)

(defclass object ()
  ((x :accessor object-x :initarg :x)
   (y :accessor object-y :initarg :y)
   (character :initarg :char)))

(defmethod object-char ((object object))
  (char-code (slot-value object 'character)))

(defun in-map (x y map)
  (if (and (< x (array-dimension map 0))
	   (>= x 0)
	   (< y (array-dimension map 1))
	   (>= y 0))
      t
      nil))

(defmethod objmove ((object object) dx dy map)
  (let ((new-x (+ (object-x object) dx))
	(new-y (+ (object-y object) dy)))
    (if (and (in-map new-x new-y map)
	     (tile-passable (aref map new-x new-y)))
	(progn
	  (setf (object-x object) new-x)
	  (setf (object-y object) new-y))
	(add-message "You bump into the wall."))))


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
