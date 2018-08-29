
(in-package #:nats.vars)


(defvar *host* #(127 0 0 1)
  "NATS IP")

(defvar *port* 4222 
  "NATS TCP/IP port")

(defvar *client-name* ""
  "Optional NATS client name")

(defvar *version* "0.1.1"
  "The current version of cl-nats")

(defvar *debug* nil
  "Set to true to debug socket IO to *trace-output*")

(defvar *encoding* :utf8
  "Character encoding to be used")

(defvar *verbose* t
  "When the verbose connection option is set to true (default from server),
 the server acknowledges each well-formed protocol message from the client 
 with a +OK message.")

(defvar *after-pong-hook* nil
  "EXPERIMENTAL")