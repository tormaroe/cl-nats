;;;; cl-nats.lisp

(in-package #:nats)
                           
(rutils.core:eval-always
  (rutils.core:re-export-symbols '#:nats.connection '#:nats)
  (rutils.core:re-export-symbols '#:nats.vars '#:nats))

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

(defun subscribe (connection subject handler &key queue-group)
  ""
  (let ((sid (inc-sid connection)))
    (set-subscription-handler connection sid handler)
    (nats-write (stream-of connection)
      (format nil "SUB ~A~@[ ~A~] ~A"
              subject
              queue-group
              sid))
    sid))
  
(defun unsubscribe (connection sid &key max-wanted)
  ""
  (nats-write (stream-of connection)
    (format nil "UNSUB ~A~@[ ~A~]" sid max-wanted)))

(defun publish (connection subject message &key reply-to)
  ""
  (nats-write (stream-of connection)
    (format nil "PUB ~A~@[ ~A~] ~A~%~A" 
            subject 
            reply-to
            (flexi-streams:octet-length message :external-format *encoding*) 
            message)))

(defun request (connection subject message handler)
  ""
  ;; create a new inbox subject, reusing sid functionality (for now)
  (let* ((inbox (format nil "INBOX.~A" (inc-sid connection)))
         (sid (subscribe connection inbox handler)))
    (publish connection 
             subject 
             message
             :reply-to inbox)))

(defun disconnect (connection)
  ""
  ; TODO when connection open only
  (handler-case
      (bt:destroy-thread (thread-of connection))
      (usocket:socket-close (socket-of connection))
    (error (e)
      (warn "Ignoring error when trying to close NATS socket: ~A" e))))

(defmacro with-connection ((var &rest args) 
                           &body body)
  "Makes a new NATS connection with supplied args (see #'make-connection),
waits for the connection, binds it to var, evaluates body, and finally
disconnects."
  `(let ((,var (wait-for-connection (make-connection ,@args))))
    (unwind-protect (progn ,@body)
      (disconnect ,var))))