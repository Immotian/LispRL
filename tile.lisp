(in-package :lisprl)

(defclass tile ()
  ((passable :accessor tile-passable :initarg :pass)
   (character :initarg :char)
   (opaque :accessor tile-opaque :initarg :opaque :initform nil)
   (visited :accessor tile-visit :initarg :visit :initform nil)
   (color :accessor tile-color :initarg :color)))

(defmethod tile-char ((tile tile))
  (char-code (slot-value tile 'character)))

(defmethod draw-tile ((tile tile) x y)
  "You have to move the cursor before calling tile-draw; tiles are intended to be used in maps, so they do not have their own x and y slots."
  (setf (tile-visit tile) t)
  (move y x)
  (attron (color-pair (tile-color tile)))
  (addch (tile-char tile))
  ;;(addch (char-code #\Space))
  (attroff (color-pair (tile-color tile))))

(defmethod draw-visited ((tile tile) x y)
  (move y x)
  (addch (tile-char tile)))

(defmethod draw-unvisited ((tile tile) x y)
  (move y x)
  (attron (color-pair COLOR_MAGENTA))
  (addch (tile-char tile))
  (attroff (color-pair COLOR_MAGENTA)))
