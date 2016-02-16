
(in-package #:nats.io)


(defun nats-read (stream)
  (let ((x (read-line stream)))
    (when nats.vars::*debug*
      (format *trace-output* "~&<< ~A~%" x))
    x))

(defun nats-write (stream msg)
  (when nats.vars::*debug*
    (format *trace-output* "~&>> ~A~%" msg))
  (format stream "~A~%" msg)
  (force-output stream))

(defun nats-write-connect (stream connection)
  (nats-write stream 
    (format nil "CONNECT ~A"
            (json:encode-json-to-string 
              `(("name" . ,(name-of connection))
                ("lang" . "LISP")
                ("version" . ,nats.vars::*version*))))))

(defun make-reader-thread (connection)
  (let ((stream (stream-of connection)))
    (bt:make-thread 
      (lambda () 
        (loop 
          ; Try parse with regex
          (let ((input (nats-read stream))) ; TODO: Protect against END-OF-FILE condition
            (cond
              ((equal input "PING") 
               (nats-write stream "PONG"))
              ((equal input "+OK") 
               nil) ; TODO: Callback queue of handlers
              ((equal (subseq input 0 4) "INFO")
               (nats-write-connect stream connection))
              (t nil))))))))

; TODO: Add conditions

; TODO: Subscriber handlers