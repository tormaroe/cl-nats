
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
  (let ((options `(("name" . ,(name-of connection))
                   ("lang" . "LISP")
                   ("version" . ,*version*)
                   ("verbose" . ,(json-bool *verbose*)))))
    (when-let (user (user-of connection))
      (if-let (pass (password-of connection))
        (setf options (pairlis '("user" "pass") `(,user ,pass) options))
        (setf options (acons "auth_token" user options))))
    (nats-write stream 
      (format nil "CONNECT ~A"
              (json:encode-json-to-string options)))))

(defun handle-info (stream connection)
  (setf (state-of connection) :connecting)
  (nats-write-connect stream connection))

(defun handle-ok (connection)
  (when (eq (state-of connection) :connecting)
    (setf (state-of connection) :connected)))

(defun handle-msg (connection input)
  (multiple-value-bind (whole matches)
      (cl-ppcre:scan-to-strings 
        "^MSG\\s+([^\\s\\r\\n]+)\\s+([^\\s\\r\\n]+)\\s+(([^\\s\\r\\n]+)[^\\S\\r\\n]+)?(\\d+)$" 
        input)
    (declare (ignore whole))
    (let* ((sid (parse-integer (aref matches 1)))
           (handler (get-subscription-handler connection sid))
           (reply-to (aref matches 3))
           (byte-size (parse-integer (aref matches 4)))
           (payload (nats-read (stream-of connection))))
      ;; Read message payload - TODO: Handle \r\n in payload, read exact bye-size
      (if reply-to
        (funcall handler payload reply-to)
        (funcall handler payload)))))

(defun handle-ping (stream)
  (nats-write stream "PONG")
  (when-it nats.vars::*after-pong-hool*
    (funcall it)))

(defun make-reader-thread (connection)
  (let ((stream (stream-of connection)))
    (bt:make-thread 
      (lambda () 
        (loop 
          (let ((input (nats-read stream))) ; TODO: Protect against END-OF-FILE condition
            (cond
              ((equal input "PING") 
               (nats-write stream "PONG"))
              ((equal input "+OK") (handle-ok connection)) ; TODO: Callback queue of handlers
              ((equal (subseq input 0 3) "MSG")
               (handle-msg connection input))
              ((equal (subseq input 0 4) "INFO")
               (handle-info stream connection))
              (t nil))))))))

; TODO: Add conditions

; TODO: Subscriber handlers