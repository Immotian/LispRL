(in-package :lisprl)

(defparameter *screen-y* 0)
(defparameter *screen-x* 0)
(defparameter *player* nil)
(defparameter *objects* nil)
(defparameter *running* t)
(defparameter *map-max-x* 80)
(defparameter *map-max-y* 25)
(defparameter *los-radius* 7)
(defparameter *message-box-y* 0)
(defparameter *message-box-x* (+ 2 *map-max-x*))
(defparameter *message-list* nil)
(defparameter *max-display-message* 5)
(defparameter *map* (make-array (list *map-max-x* *map-max-y*) :initial-element nil))



(start-color)
  (init-pair COLOR_BLACK   COLOR_BLACK   COLOR_BLACK)
  (init-pair COLOR_GREEN   COLOR_GREEN   COLOR_BLACK)
  (init-pair COLOR_RED     COLOR_RED     COLOR_BLACK)
  (init-pair COLOR_CYAN    COLOR_CYAN    COLOR_BLACK)
  (init-pair COLOR_WHITE   COLOR_WHITE   COLOR_BLACK)
  (init-pair COLOR_MAGENTA COLOR_MAGENTA COLOR_BLACK)
  (init-pair COLOR_BLUE    COLOR_BLUE    COLOR_BLACK)
  (init-pair COLOR_YELLOW  COLOR_YELLOW  COLOR_BLACK)
