;;;; package.lisp

(defpackage #:nats.connection
  (:use #:cl)
  (:export #:connection
           #:name-of
           #:host-of
           #:port-of
           #:socket-of
           #:stream-of
           #:thread-of
           #:inc-sid
           #:set-subscription-handler
           #:get-subscription-handler))

(defpackage #:nats.vars
  (:use #:cl)
  (:export #:*host*
           #:*port*
           #:*client-name*
           #:*encoding*))

(defpackage #:nats.io
  (:use #:cl #:nats.connection #:nats.vars)
  (:export #:nats-read
           #:nats-write
           #:make-reader-thread))

(defpackage #:nats
  (:use #:cl #:nats.connection #:nats.vars #:nats.io)
  (:export #:make-connection
           #:connect
           #:subscribe
           #:unsubscribe
           #:publish
           #:request
           #:disconnect
           #:with-connection))