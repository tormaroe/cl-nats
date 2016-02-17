
;;; This script will create 9 consumers and 1 producer.
;;; The producer will send messages with five different subjects,
;;; 5000 messages in total. The consumers will all subscribe
;;; differently, and then count the number of messages they get.
;;; Finally we assert the expected number of received messages
;;; per consumer. 

(format t "CL-NATS Example 2: Pub/sub advanced~%")

(defstruct consumer 
  connection (count 0))

(defvar consumers
  (loop for i from 0 to 8
        collect (make-consumer 
                  :connection 
                  (nats:make-connection :name (format nil "con~A" i)))))

(defvar producer (nats:make-connection :name "producer"))

(sleep 1)

(defvar subjects 
  '(">" "test.>"
    "test.foo.*" "test.bar.*"
    "test.foo.a" "test.foo.b"
    "test.bar.a" "test.bar.b"
    "test.*.a"))

(defun subscribe (index)
  (let ((c (nth index consumers)))
    (nats:subscribe 
      (consumer-connection c)
      (nth index subjects)
      (lambda (msg)
        (declare (ignore msg))
        (incf (consumer-count c))))))

(loop for i from 0 to 8 do (subscribe i))

(format t "Publishing 5000 messages..")
(finish-output)
(dotimes (i 1000)
  (nats:publish producer "test.foo.a" "yo!")
  (nats:publish producer "test.foo.b" "yo!")
  (nats:publish producer "test.bar.a" "yo!")
  (nats:publish producer "test.bar.b" "yo!")
  (nats:publish producer "some.random.subject" "yo!"))
(format t "DONE~%")

(defvar expecteds '(5000 4000 2000 2000 1000 1000 1000 1000 2000))

(format t "Waiting a couple of seconds..")
(finish-output)
(sleep 2)
(format t "DONE~%")

(defun assert-message-count (index)
  (let* ((c (nth index consumers))
         (name (nats.connection:name-of (consumer-connection c)))
         (expected (nth index expecteds))
         (actual (consumer-count c)))
    (if (= actual expected)
      (format t "~&~A got the expected message count of ~A~%" name actual)
      (format t "~&Expected ~A messages for ~A but got ~A~%" name expected actual))))

(loop for i from 0 to 8 do (assert-message-count i))

(format t "~%A grand total of ~A messages received!~%"
          (reduce #'+ expecteds))