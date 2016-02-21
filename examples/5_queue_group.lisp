
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

(defvar *producer* (wait-for-connection (make-connection)))

(loop for i from 1 to 10
      do (publish *producer* "some-subject" 
                  (format nil "Message ~A" i)))