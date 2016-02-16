;;;; cl-nats.lisp

(in-package #:nats)
                           
(defun connect (connection)
  ""
  ; TODO: disconnect first if needed
  (let* ((socket (usocket:socket-connect (host-of connection) 
                                         (port-of connection)
                                         :element-type '(unsigned-byte 8)))
         (stream (flexi-streams:make-flexi-stream (usocket:socket-stream socket)
                                                  :external-format 
                                                  (flexi-streams:make-external-format
                                                    *encoding* :eol-style :crlf))))
    (setf (socket-of connection) socket)
    (setf (stream-of connection) stream)
    (setf (thread-of connection) (make-reader-thread connection))
    connection))

(defun make-connection (&key host port name)
  "Creates a ready to be used NATS connection."
  (let ((conn (make-instance 'connection
                             :host (or host *host*)
                             :port (or port *port*)
                             :name (or name *client-name*))))
    (connect conn)))

(defun subscribe (connection subject handler &key (queue-group ""))
  ""
  (let ((sid (inc-sid connection)))
    (set-subscription-handler connection sid handler)
    (nats-write (stream-of connection)
      (format nil "SUB ~A ~A ~A"
              subject
              queue-group
              sid))
    sid))
  
(defun unsubscribe (connection sid &key max-wanted)
  ""
  nil)

(defun publish (connection subject message) ;&keys callback)
  ""
  (nats-write (stream-of connection)
    (format nil "PUB ~A ~A~%~A" 
            subject 
            (flexi-streams:octet-length message :external-format *encoding*) 
            message)))

(defun request (connection subject handler)
  ""
  nil)

(defun disconnect (connection)
  ""
  ; TODO when connection open only
  (handler-case
      (bt:destroy-thread (thread-of connection))
      (usocket:socket-close (socket-of connection))
    (error (e)
      (warn "Ignoring error when trying to close NATS socket: ~A" e))))

(defmacro with-connection ((connection &key host 
                                            port 
                                            servers 
                                            verbose) 
                           &body body)
  ""
  ; TODO: Accept &rest and pass it on with apply
  `(let ((,connection (make-connection :host ,host
                                       :port ,port)))
    (unwind-protect (progn ,@body)
      (disconnect ,connection))))