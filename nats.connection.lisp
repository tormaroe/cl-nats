
(in-package #:nats.connection)

(defclass connection () 
  ((name :initarg :name 
         :accessor name-of)
   (host :initarg :host 
         :accessor host-of)
   (port :initarg :port 
         :accessor port-of)
   (socket :initarg :socket 
           :accessor socket-of)
   (stream :initarg :stream 
           :accessor stream-of)
   (thread :initarg :thread 
           :accessor thread-of)
   (sid-sequence :initform 0 
                 :accessor sid-sequence-of)
   (subscription-handlers :initform (make-hash-table) 
                          :accessor subscription-handlers-of)))

(defun inc-sid (connection)
  (incf (sid-sequence-of connection)))

(defun set-subscription-handler (connection sid handler)
  (setf (gethash sid (subscription-handlers-of connection))
        handler))

(defun get-subscription-handler (connection sid)
  (gethash sid (subscription-handlers-of connection)))