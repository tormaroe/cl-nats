
;;; This script demonstrates having one connection with multiple subscriptions

(defvar *sub* (nats:make-connection :name "*sub*"))
(defvar *pub* (nats:make-connection :name "*pub*"))

(nats:wait-for-connection *sub*)
(nats:wait-for-connection *pub*)

(nats:subscribe *sub* "subject1"
  (lambda (msg)
    (format t "Got subject1 message: ~A~%" msg)))

(nats:subscribe *sub* "subject2"
  (lambda (msg)
    (format t "Got subject2 message: ~A~%" msg)))

(nats:subscribe *sub* "subject3"
  (lambda (msg)
    (format t "Got subject3 message: ~A~%" msg)))


(loop for subject in (rutils:shuffle '("subject1" "subject1"
                                       "subject2" "subject2"
                                       "subject3" "subject3"))
      do (nats:publish *pub* subject "hello!")
      finally (format t "Publisher done!"))