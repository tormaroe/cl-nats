
(format t "
+---------------------------------------------------+
|                                                   |
|        CL-NATS EXAMPLE 1: SIMPLE PUB/SUB          |
|                                                   |
+---------------------------------------------------+
")

(format t "Setting *debug* := true to trace all socket traffic~%")
(setf nats:*debug* t)

(format t "
|                                                   |
|  Making two connections to NATS                   |
|  One producer and one consumer                    |
|                                                   |
")

(defvar producer (nats:make-connection :name "producer"))
(defvar consumer (nats:make-connection :name "consumer"))

(defun stop-pubsub ()
  (nats:disconnect producer)
  (nats:disconnect consumer)
  (format t "Producer and consumer disconnected.~%"))

(nats:wait-for-connection (list producer consumer))

(defvar subject "test")
(format t "
|                                                   |
|  Subscribing consumer to subject test             |
|  Registering handler which will output messages   |
|                                                   |
")

(nats:subscribe consumer subject
  (lambda (msg)
    (format t "~&CONSUMER GOT MESSAGE '~A'~%" msg)
    (format t "~%Example complete!
Evaluate (stop-pubsub) to disconnect from NATS.~%")))

(format t "
|                                                   |
|  Waiting one second, then producer will publish   |
|  a message to test subject                        |
|                                                   |
")
(sleep 1)

(nats:publish producer subject "hello, world!")
