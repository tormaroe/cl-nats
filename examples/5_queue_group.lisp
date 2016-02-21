
(use-package :nats)

(defun make-queue-processor (n)
  (subscribe (make-connection)
             "some-subject"
             (lambda (msg)
               (format t "~A handled by #~A~%" msg n))
             :queue-group "qg1"))

(loop for i from 1 to 3
      do (make-queue-processor i))

(subscribe (make-connection) "some-subject"
           (lambda (msg)
             (format t "~A observed by supervisor~%" msg)))

(with-connection (producer :name "producer")
  (loop for i from 1 to 10
        do (publish producer "some-subject" 
                    (format nil "Message ~A" i))))


;;; Sample output
;;;
; Message 3 handled by #2
; Message 6 handled by #2
; Message 1 handled by #3
; Message 2 handled by #3
; Message 4 handled by #3
; Message 8 handled by #3
; Message 9 handled by #3
; Message 1 observed by supervisor
; Message 2 observed by supervisor
; Message 3 observed by supervisor
; Message 4 observed by supervisor
; Message 5 observed by supervisor
; Message 6 observed by supervisor
; Message 7 observed by supervisor
; Message 8 observed by supervisor
; Message 9 observed by supervisor
; Message 10 observed by supervisor
; Message 5 handled by #1
; Message 7 handled by #1
; Message 10 handled by #1