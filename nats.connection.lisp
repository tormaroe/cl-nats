
(in-package #:nats.connection)

(defclass connection () 
  ((name :initarg :name :accessor name-of)
   (host :initarg :host :accessor host-of)
   (port :initarg :port :accessor port-of)
   (socket :initarg :socket :accessor socket-of)
   (stream :initarg :stream :accessor stream-of)
   (thread :initarg :thread :accessor thread-of)
   (next-sid :initform 1 :accessor next-sid-of)))
