(in-package :lisprl)
(defclass creature (object)
  ((max-hp :accessor creature-max-hp :initarg :mhp)
   (hp :accessor creature-hp :initarg :hp)
   (str :accessor creature-str :initarg :str)
   (ai :accessor creature-ai :initarg :ai)
   (alliance :accessor creature-ally :initarg :ally)))

(defun creature-at-place (x y creature-list)
  (find-if #'(lambda (creature) (and (= (object-x creature) x)
				(= (object-y creature) y)))
	creature-list))

(defmethod move-thing ((creature creature) dx dy map)
  (let*
      ((new-x (+ dx (object-x creature)))
       (new-y (+ dy (object-y creature)))
       (other-creature (creature-at-place new-x new-y (cons *player* *creature-list*))))
    (cond (other-creature (act-on-creature creature other-creature))
	  (t (call-next-method)))))

(defmethod act-on-creature ((creature creature) (other-creature creature))
  (if (eq (creature-ally creature) (creature-ally other-creature))
	 (swap-positions creature other-creature)
	(attack creature other-creature)))

(defmethod swap-positions ((creature creature) (other-creature creature))
  (rotatef (object-x creature) (object-x other-creature))
  (rotatef (object-y creature) (object-y other-creature)))

(defmethod attack ((creature creature) (other-creature creature))
  (lose-life other-creature (creature-str creature)))

(defmethod lose-life ((creature creature) damage)
  (setf (creature-hp creature) (- (creature-hp creature) damage))
  (if (<= (creature-hp creature) 0)
      (die creature)))

(defmethod die ((creature creature))
  (setf *creature-list* (delete-if #'(lambda (creature-in-list)
		 (eq creature-in-list creature))
	     *creature-list*))
  (push (create-corpse creature) *objects*))

(defmethod create-corpse ((creature creature))
  (make-instance 'object
		 :x (object-x creature)
		 :y (object-y creature)
		 :char #\%))
