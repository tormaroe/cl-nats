
(in-package #:nats.connection)

(defclass connection () 
  ((name :initarg :name 
         :accessor name-of)
   (host :initarg :host 
         :accessor host-of)
   (port :initarg :port 
         :accessor port-of)
   (user :initarg :user
         :initform nil
         :accessor user-of)
   (password :initarg :password
             :initform nil
             :accessor password-of)
   (state :initform :disconnected
          :accessor state-of)
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

(defun connectedp (connection)
  (eq (state-of connection) :connected))

(defun not-connected-p (connection)
  (not (eq (state-of connection) :connected)))

(defun wait-for-connection (connections &key (sleeptime 0.01))
  (let ((orig connections)
        (connections (if (typep connections 'list)
                       connections
                       (list connections))))
    (loop while (some #'not-connected-p connections)
          do (sleep sleeptime))
    orig))

;; TODO: Add state-related funcs
;; defun wait-for-connection (x | xs).., with timeout ?